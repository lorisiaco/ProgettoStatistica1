load("G21.mat");
T=t;
%--------------------------MODELLI DI REGRESSIONE-------------------------
%scelgo la prima Y(PM10)
Y_pm10=T{:,15}
%carico nei vettori le variabili per effettuare i vari confronti
X1=T{:,19}      %Benzina_vendita_rete_ord
X2=T{:,20}      %Gasolio_motori_rete_ord
X3=T{:,21}      %Gasolio_riscaldamento
X_TotCarb=[[X1],[X2],[X3]]
X10=T{:,16}     %Temperatura
X20=T{:,17}     %Umidità_relativa
X30=T{:,18}     %Pioggia_Cumulata
X_TotTemp=[[X10],[X20],[X30]]
%scelgo la seconda Y
Y_no2=T{:,12}
%-----------------------------MODELLI PER PM10-----------------------
%trovo il modello di regressione migliore tra le variabili carburanti per il PM10 con lo Stepwise
ModelloPm10Carb=stepwiselm(X_TotCarb,Y_pm10,'constant','Upper','linear')
%trovo il modello di regressione migliore tra le variabili temperatura per il PM10 con lo Stepwise
ModelloPm10Temp=stepwiselm(X_TotTemp,Y_pm10,'constant','Upper','linear')
%-----------------------------MODELLI PER NO2-----------------------
%trovo il modello di regressione migliore tra le variabili carburanti per il N02 con lo Stepwise
ModelloNO2Carb=stepwiselm(X_TotCarb,Y_no2,'constant','Upper','linear')
%trovo il modello di regressione migliore tra le variabili temperatura per il N02 con lo Stepwise
ModelloNO2Temp=stepwiselm(X_TotTemp,Y_no2,'constant','Upper','linear')
%--------------------VERIFICA DI ESISTENZA-----------------------------
%Verifica condizioni di esistenza per ModelloPm10Carb
X_varPM10=[[X3]]
uno=ones(66,1)
Z=[uno,X_varPM10]
Z1=Z'
determinantePM10=det(Z1*Z)      %positivo
%Verifica condizioni di esistenza per ModelloPm10Temp
X_varPM101=[X1],[X2],[[X3]]
Z2=[uno,X_varPM101]
Z3=Z2'
determinantePM101=det(Z3*Z2)      %positivo
%Verifica condizioni di esistenza per ModelloNO2Carb
X_varNO2=[X1],[X2],[[X3]]
Z4=[uno,X_varNO2]
Z5=Z4'
determinanteNO2=det(Z5*Z4)      %positivo
%Verifica condizioni di esistenza per ModelloNO2Carb
X_varNO21=[[X1]]
Z6=[uno,X_varNO21]
Z7=Z6'
determinanteNO21=det(Z7*Z6)        %positivo
%-------------------------CONFRONTO------------------------------------
R2PM10=ModelloPm10Carb.Rsquared.Adjusted
R2PM101=ModelloPm10Temp.Rsquared.Adjusted
%Notiamo che il modello PM10Temp ha l'r maggiore 
R2NO2=ModelloNO2Carb.Rsquared.Adjusted
R2NO21=ModelloNO2Temp.Rsquared.Adjusted
%Notiamo che il modello NO2Temp ha l'r maggiore 
%Il R2 del modello PM10 é superiore di circa del 18%, significa che spiega piú casi rispetto al modello di NO2
PVPM10=ModelloPm10Carb.Coefficients.pValue
PVPM101=ModelloPm10Temp.Coefficients.pValue
PVN02=ModelloNO2Carb.Coefficients.pValue
PVN021=ModelloNO2Temp.Coefficients.pValue
%i p-value sono bassi e rifiutano H0 tranne il p-value dell'intercetta del
%modello NO2Carb
FtestPM10=coefTest(ModelloPm10Carb)
F1testPM10=coefTest(ModelloPm10Temp)
FtestNO2=coefTest(ModelloNO2Carb)
F1testNO2=coefTest(ModelloNO2Temp)
%Tutte e 4 molto piccoli tendenti a zero 
%-------PM10Carb-----------------
MSEPM10=ModelloPm10Carb.MSE %abbastanza significativo dato che vale 122.4591
ResiduiPM10 = ModelloPm10Carb.Residuals.Raw
Media=mean(ResiduiPM10) %Media dei residui bassa
plot(ResiduiPM10)
yline(0,'r','LineWidth',3) 
yline(mean(ResiduiPM10),'b','LineWidth',2) 
histfit(ResiduiPM10)
%-------PM10Temp-----------------
MSEPM101=ModelloPm10Temp.MSE % 48.3615 minore del modello Carb
ResiduiPM101 = ModelloPm10Temp.Residuals.Raw
Media1=mean(ResiduiPM101) %Media dei residui bassa
plot(ResiduiPM101)
yline(0,'r','LineWidth',3) 
yline(mean(ResiduiPM101),'b','LineWidth',2) 
histfit(ResiduiPM101)
%-------NO2Carb-----------------
MSENO2=ModelloNO2Carb.MSE %abbastanza significativo dato che vale   96.6704
ResiduiNO2 = ModelloNO2Carb.Residuals.Raw
Media2=mean(ResiduiNO2) %Media dei residui bassa
plot(ResiduiNO2)
yline(0,'r','LineWidth',3) 
yline(mean(ResiduiNO2),'b','LineWidth',2) 
histfit(ResiduiNO2)
%-------NO2Temp-----------------
MSENO21=ModelloNO2Temp.MSE % 73.9609 minore del modello Carb
%il miglior MSE di tutti i modelli rimane quello del modello PM10Temp
ResiduiNO21 = ModelloNO2Temp.Residuals.Raw
Media3=mean(ResiduiNO21) %Media dei residui bassa
plot(ResiduiNO21)
yline(0,'r','LineWidth',3) 
yline(mean(ResiduiNO21),'b','LineWidth',2) 
histfit(ResiduiNO21)
%PM10Temp é il modello migliore in base ai dati ottenuti