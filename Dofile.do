cd "C:\Users\39348\Downloads\Tesi"
use "Dataset ESS"

*Controllo delle variabili
tab1 stflife bthcld nbthcld gndr eisced agea wkhtot rlgdgr maritalb health wrkctra, m
codebook stflife bthcld nbthcld gndr eisced agea wkhtot rlgdgr maritalb health wrkctra 
lab list stflife bthcld nbthcld gndr eisced agea wkhtot rlgdgr maritalb health wrkctra 

bysort essround: su stflife
bysort essround: su bthcld
bysort essround: su nbthcld 

bysort cntry: su stflife
bysort cntry: su bthcld
bysort cntry: su nbthcld 

*Ricodifica delle variabili
recode bthcld (2 = 0 "No") (else=.), generate(bthcld_m)
lab var bthcld_m "Avere figli"
tab bthcld bthcld_m

recode nbthcld (1 = 1 "1") (2 = 2 "2") (3 = 3 "3") (4 5 6 7 8 9 10 = 4 "4+") (else=.), generate(nbthcld_m)
lab var nbthcld_m "Numero di figli"
tab nbthcld nbthcld_m

egen children=rowtotal(bthcld_m nbthcld_m)
tab1 bthcld_m nbthcld_m children

recode eisced (1 2 = 1 "Basso") (3 4 5 = 2 "Medio") (6 7 = 3 "Alto") (else=.), generate(eisced_m)
lab var eisced_m "Livello di istruzione"
tab eisced eisced_m

recode maritalb (1 2 = 1 "Sposato/Unione civile") (3 4 = 2 "Divorziato/Separato") (5 = 3 "Vedovo") (6 = 4 "Celibe") (else=.), generate(maritalb_m)
lab var maritalb_m "Stato maritale"
tab maritalb maritalb_m

recode wrkctra (1 = 1 "Indeterminato") (2 = 2 "Determinato") (3 = 3 "Senza contratto") (.a = 4 "Non lavoratore") (else=.), generate(wrkctra_m)
lab var wrkctra_m "Contratto di lavoro"
tab wrkctra wrkctra_m

recode wkhtot (0 1 2 3 4 5 6 7 8 9 10 = 1 "0-10") (11 12 13 14 15 16 17 18 19 20 = 2 "11-20") (21 22 23 24 25 26 27 28 29 30 = 3 "21-30") (31 32 33 34 35 36 37 38 39 40 = 4 "31-40") (41 42 43 44 45 46 47 48 49 50 = 5 "41-50") (51 52 53 54 55 56 57 58 59 60 = 6 "51-60")(61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 = 7 "61-80") (else=.), generate(wkhtot_m)
lab var wkhtot_m "Numero di ore di lavoro (staordinari inclusi)"
tab wkhtot wkhtot_m

*Missing
drop if essround==10
drop if essround < 9
egen nmiss = rownonmiss(stflife children gndr eisced_m agea wkhtot_m rlgdgr maritalb_m health wrkctra_m)
tab nmiss
drop if missing(stflife, children, gndr, eisced_m, agea, wkhtot_m, rlgdgr, maritalb_m, health, wrkctra_m)

*Monovariate e bivariate
tab1 children eisced_m gndr maritalb_m wrkctra_m health wkhtot_m

graph hbox stflife, note("ESS, round 9", size(small)) ylabel(0(1)10)
histogram stflife
graph hbox rlgdgr, note("ESS, round 9", size(small)) ylabel(0(1)10)
histogram rlgdgr
graph hbox agea, note("ESS, round 9", size(small)) ylabel(10(10)95)
histogram agea
graph hbox wkhtot_m, note("ESS, round 9", size(small)) ylabel(0(10)80)
histogram wkhtot_m

*Regressioni
collin stflife children gndr eisced agea wkhtot rlgdgr maritalb health wrkctra

reg stflife i.children
reg stflife i.children if gndr==1
reg stflife i.children if gndr==2
 
reg stflife i.children i.gndr i.eisced_m i.maritalb_m i.health i.wrkctra_m i.wkhtot_m agea rlgdgr

reg stflife i.children##i.gndr i.eisced_m i.maritalb_m i.health i.wrkctra_m i.wkhtot_m agea rlgdgr

reg stflife i.children##i.eisced_m i.gndr i.maritalb_m i.health i.wrkctra_m i.wkhtot_m agea rlgdgr

reg stflife i.children##i.maritalb_m i.gndr i.eisced_m i.health i.wrkctra_m i.wkhtot_m  agea rlgdgr

reg stflife i.children##i.health i.gndr i.eisced_m i.maritalb_m i.wrkctra_m i.wkhtot_m agea rlgdgr

reg stflife i.children##i.wrkctra_m i.gndr i.eisced_m i.maritalb_m i.health i.wkhtot_m agea rlgdgr

reg stflife i.children##i.wkhtot_m i.gndr i.eisced_m i.maritalb_m i.health i.wrkctra_m agea rlgdgr

reg stflife i.children##c.agea i.gndr i.eisced_m i.maritalb_m i.health i.wrkctra_m i.wkhtot_m rlgdgr

reg stflife i.children##c.rlgdgr i.gndr i.eisced_m i.maritalb_m i.health i.wrkctra_m i.wkhtot_m agea

margins, at (children=(0(1)4) gndr=(1 2))
margins, at (children=(0(1)4) eisced_m=(1 2 3))
margins, at (children=(0(1)4) maritalb_m=(1(1)4))
margins, at (children=(0(1)4) health=(1(1)5))
margins, at (children=(0(1)4) wrkctra_m=(1(1)4))
margins, at (children=(0(1)4) wkhtot_m=(1(1)7))
margins, at (children=(0(1)4) agea=(20(20)80))
margins, at (children=(0(1)4) rlgdgr=(0(3)10))
marginsplot, noci
