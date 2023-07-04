use "C:\Users\Antonini\Desktop\Does Inequality affects Growth - Econometrics Project\dummydevelop.dta", clear

*DOES INEQUALITY NEGATIVELY AFFECT ECONOMIC GROWTH? ARE THERE DIFFERENCES IN ITS IMPACT BETWEEN DVELOPED (OECD) AND NON DEVELOPED NATIONS

*declaring the panel and the time variables:

xtset geo period 

*WHAT DOES THE PANEL CONSIST OF?

des 

xtsum lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt

*TRETMENT OF UNOBSERVED HETEROGENEITY: 

*FIXED EFFECTS:

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt, fe  

estimates store fixed

*RANDOM EFFECTS:

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt, re

estimates store random 

*FIXED EFFECTS OR RANDOM EFFECTS?

*THE HAUSMAN TEST: testing whether the individual characteristics are correlated with the regressors

hausman fixed random, sigmamore

*Because of a low P>chi2 (=0.0000), we reject the hypothesis of random effects, opting for the fixed effects option

*TREND AND DETRENDING: TIME FIXED EFFECTS 

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period, fe  
 
testparm period 

*Because of a low P>F, we reject the hypothesis of jointly null time fixed effects: time fixed effects are needed in order to detrending the regression

*HETEROSKEDASTICITY 

*GRAPHICALLY DISPLAYING ERROR DISTRIBUTION, IS HOMESKEDASTICITY A VALID HYPOTHESIS?

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period, fe
predict u_hat, res 
gen u_hatsq=u_hat^2
histogram u_hatsq, normal 

*WALD TEST 

ssc install xttest3

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period, fe robust

xttest3

*We reject the hypothesis of homoskedasticity, robust coefficient are needed to account for heteroskedasticity 

*TESTING FOR SERIAL CORRELATION (Wooldridge test)

xtserial lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period 

*Because of a low P>F (=0.0000), we reject the null (no first order autocorrelation)

*TESTING NON-LINEAR RELATION

gen gini_mktsq = gini_mkt^2

gen gini_mktcu = gini_mkt^3

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period gini_mktcu gini_mktsq, fe robust

test gini_mktsq gini_mktcu

*Because of high P>F, we can exclude these variables from the regression

*Checking for differences between OECD and non-OECD countries:

gen gini_mktdevel = gini_mkt*devel

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period gini_mktdevel, fe robust

*OECD countries characterized by higher (negative) impact of inequality on growth, but such a difference with non-OECD countries is statistically insignificant

*Checking for differences between OECD and non-OECD countries during financial crises period:

gen gini_mktdum_fincrisis = gini_mkt*dum_fincrisis

gen gini_mktdum_fincrisisdevel = gini_mkt*dum_fincrisis*devel

xtreg lrgdpna_pc lhc lkg lrer ltraderesid lcredit linflation_na infra_index ltot lFDIstock_ipol actotal sd_growth urbanpop emprate remittances gini_mkt period gini_mktdevel gini_mktdum_fincrisis gini_mktdum_fincrisisdevel, fe robust

*The interaction variables are all statistically insignificant. Statistically no conclusion.

*Conclusion

*Income inequality positively affect GDP growth with a strongly statistically significance. There are no statistically significant evidence of a difference between developed and non developed countries in the reltion between inequality and growth. 
  