//
//  CalcGrades.m
//  TFHealth
//
//  Created by nico on 14-8-11.
//  Copyright (c) 2014年 studio37. All rights reserved.
//

#import "CalcGrades.h"

@implementation CalcGrades

/*健康评分用到的宏定义*/
#define M_SLM_RATE	1.19	/*设定的男性肌肉百分比的最高值*/
#define	M_SLM_GRADE	90.0	/*设定的男性肌肉的最高评分*/
#define M_FM_GRADE0	90.0	/*设定的男性脂肪量的最高评分*/
#define	M_FM_GRADE1	73.0	/*设定的男性脂肪量第一段的最低评分*/
#define	M_FM_GRADE2	30.0	/*男性脂肪量第一段到最高分之间的差值*/
#define	M_FM_GRADE3	40.0	/*男性第三段和第四段的基础分值（70分的一半。这两端可以分成不同的区间）*/
#define	M_PM_RATE	18.1	/*设定的男性蛋白质体重百分比的最高值*/
#define	M_PM_GRADE	90.0	/*设定的男性蛋白质的最高评分*/
#define	M_BMM_RATE	5.9		/*设定的男性骨质体重百分比的最高值*/
#define M_BMM_GRADE	90.0	/*设定的男性骨质的最高评分*/

#define	F_SLM_RATE	1.15	/*设定的女性肌肉百分比的最高值*/
#define	F_SLM_GRADE	90.0	/*设定的女性肌肉的最高评分*/
#define	F_FM_GRADE0	90.0	/*设定的女性脂肪量的最高评分*/
#define	F_FM_GRADE1	69.0	/*设定的女性脂肪量第一段的最低评分*/
#define	F_FM_GRADE2	20.0	/*女性脂肪量第一段到最高分之间的差值*/
#define	F_FM_GRADE3	35.0	/*女性第三段和第四段的基础分值（70分的一半。这两端可以分成不同的区间）*/
#define	F_PM_RATE	15.9	/*设定的女性蛋白质体重百分比的最高值*/
#define	F_PM_GRADE	90.0	/*设定的女性蛋白质的最高评分*/
#define	F_BMM_RATE	5.5		/*设定的女性骨质体重百分比的最高值*/
#define	F_BMM_GRADE	90.0	/*设定的女性骨质的最高评分*/

+(double)calcScore:(double)pbslm fat:(double)pbfm p:(double)pbpm m:(double)pbmm g:(int)gender a:(int)age
{
    double Pslm, Pfm, Ppm, Pmm, dtotal;
	Pslm =pbslm;  //肌肉百分比
	Pfm = pbfm*100;   //脂肪百分比
	Ppm = pbpm*100;   //蛋白质百分比
	Pmm = pbmm*100;   //骨质百分比
    BOOL bGender = gender!=1;
    
    double m_fGradeFM,m_fGradeSLM,m_fGradePM,m_fGradeMM; // TODO 哪定义的
	
	if(bGender == FALSE)//男
	{
		if(Pfm<10.0){
			m_fGradeFM=Pfm;
			m_fGradeFM=m_fGradeFM/10.0;
			m_fGradeFM=m_fGradeFM*M_FM_GRADE1;
		}
		else if((Pfm>=10.0)&&(Pfm<=20.0)){
			if(Pfm==15.0){
				m_fGradeFM=M_FM_GRADE0;
			}
			else{
				if(Pfm<15.0){
					m_fGradeFM=Pfm-10.0;
				}
				else{
					m_fGradeFM=20.0-Pfm;
				}
				m_fGradeFM=m_fGradeFM/5.0;
				m_fGradeFM=m_fGradeFM*M_FM_GRADE2;
				m_fGradeFM+=M_FM_GRADE1;
			}
		}
		else if((Pfm>20.0)&&(Pfm<=35.0)){
			m_fGradeFM=35.0-Pfm;
			m_fGradeFM=m_fGradeFM/15.0;
			m_fGradeFM=m_fGradeFM*M_FM_GRADE3;
			m_fGradeFM+=M_FM_GRADE3;
		}
		else{
			m_fGradeFM=Pfm-35.0;
			m_fGradeFM=m_fGradeFM/35.0;
			m_fGradeFM=m_fGradeFM*M_FM_GRADE3;
			if(m_fGradeFM>=M_FM_GRADE3){
				m_fGradeFM=0;
			}
			else{
				m_fGradeFM=M_FM_GRADE3-m_fGradeFM;
			}
		}
		/*-------------------------------------------------------------------*/
		m_fGradeSLM=Pslm/M_SLM_RATE;
		m_fGradeSLM=m_fGradeSLM*M_SLM_GRADE;
		if(m_fGradeSLM>100.0){
			m_fGradeSLM=100.0;
		}
		/*-------------------------------------------------------------------*/
		m_fGradePM=Ppm/M_PM_RATE;
		m_fGradePM=m_fGradePM*M_PM_GRADE;
		if(m_fGradePM>100.0){
			m_fGradePM=100.0;
		}
		/*-------------------------------------------------------------------*/
		m_fGradeMM=Pmm/M_BMM_RATE;
		m_fGradeMM=m_fGradeMM*M_BMM_GRADE;
		if(m_fGradeMM>100.0){
			m_fGradeMM=100.0;
		}
        /*		if(pslm<0.85) islm = 0;
         else if((pslm>=0.85) && (pslm<0.91)) islm = 1;
         else if((pslm>=0.91)&&(pslm<0.97)) islm = 2;
         else if((pslm>=0.97)&&(pslm<1.08)) islm = 3;
         else if((pslm>=1.08)&&(pslm<1.13)) islm = 4;
         else if((pslm>=1.13)&&(pslm<1.19)) islm = 5;
         else if((pslm>=1.19)) islm = 6;
         
         if((pfm<5.0)||(pfm >= 35.0)) ifm = 0;
         else if(((pfm >=5)&&(pfm<8))||((pfm>=25)&&(pfm<35))) ifm = 1;
         else if(((pfm >=8)&&(pfm<10))||((pfm>=20)&&(pfm<25))) ifm = 3;
         else if((pfm >=10)&&(pfm<20)) ifm = 4;
         
         if(ppm<14.0) ipm = 0;
         else if((ppm>=14)&&(ppm<14.7)) ipm = 1;
         else if((ppm>=14.7)&&(ppm<15.4)) ipm =2;
         else if((ppm>=15.4)&&(ppm<16.8)) ipm =3;
         else if((ppm>=16.8)&&(ppm<17.4)) ipm =4;
         else if((ppm>=17.4)&&(ppm<18.1)) ipm =5;
         else if(ppm>=18.1) ipm =6;
         
         if(pmm<4.6) imm = 0;
         else if((pmm>=4.6)&&(pmm<4.8)) imm = 1;
         else if((pmm>=4.8)&&(pmm<5.0)) imm = 2;
         else if((pmm>=5.0)&&(pmm<5.4)) imm = 3;
         else if((pmm>=5.4)&&(pmm<5.7)) imm = 4;
         else if((pmm>=5.7)&&(pmm<5.9)) imm = 5;
         else if(pmm>=5.9) imm = 6;*/
	}
	else {
		if(Pfm<18.0){
			m_fGradeFM=Pfm;
			m_fGradeFM=m_fGradeFM/18.0;
			m_fGradeFM=m_fGradeFM*F_FM_GRADE1;
		}
		else if((Pfm>=18.0)&&(Pfm<=28.0)){
			if(Pfm==23.0){
				m_fGradeFM=F_FM_GRADE0;
			}
			else{
				if(Pfm<23.0){
					m_fGradeFM=Pfm-18.0;
				}
				else{
					m_fGradeFM=28.0-Pfm;
				}
				m_fGradeFM=m_fGradeFM/5.0;
				m_fGradeFM=m_fGradeFM*F_FM_GRADE2;
				m_fGradeFM+=F_FM_GRADE1;
			}
		}
		else if((Pfm>28.0)&&(Pfm<=43.0)){
			m_fGradeFM=43.0-Pfm;
			m_fGradeFM=m_fGradeFM/15.0;
			m_fGradeFM=m_fGradeFM*F_FM_GRADE3;
			m_fGradeFM+=F_FM_GRADE3;
		}
		else{
			m_fGradeFM=Pfm-43.0;
			m_fGradeFM=m_fGradeFM/43.0;
			m_fGradeFM=m_fGradeFM*F_FM_GRADE3;
			if(m_fGradeFM>=F_FM_GRADE3){
				m_fGradeFM=0;
			}
			else{
				m_fGradeFM=F_FM_GRADE3-m_fGradeFM;
			}
		}
		/*-------------------------------------------------------------------*/
		m_fGradeSLM=Pslm/F_SLM_RATE;
		m_fGradeSLM=Pslm*F_SLM_GRADE;
		if(m_fGradeSLM>100.0){
			m_fGradeSLM=100.0;
		}
		/*-------------------------------------------------------------------*/
		m_fGradePM=Ppm/F_PM_RATE;
		m_fGradePM=m_fGradePM*F_PM_GRADE;
		if(m_fGradePM>100.0){
			m_fGradePM=100.0;
		}
		/*-------------------------------------------------------------------*/
		m_fGradeMM=Pmm/F_BMM_RATE;
		m_fGradeMM=m_fGradeMM*F_BMM_GRADE;
		if(m_fGradeMM>100.0){
			m_fGradeMM=100.0;
		}
        /*		if(pslm<0.80) islm = 0;
         else if((pslm>=0.80)&&(pslm<0.87)) islm = 1;
         else if((pslm>=0.87)&&(pslm<0.94)) islm = 2;
         else if((pslm>=0.94)&&(pslm<1.06)) islm = 3;
         else if((pslm>=1.06)&&(pslm<1.11)) islm = 4;
         else if((pslm>=1.11)&&(pslm<1.15)) islm = 5;
         else if((pslm>=1.15)) islm = 6;
         
         if((pfm<8)||(pfm >= 43)) ifm = 0;
         else if(((pfm >=8)&&(pfm<13))||((pfm>=33)&&(pfm<43))) ifm = 1;
         else if(((pfm >=13)&&(pfm<18))||((pfm>=28)&&(pfm<33))) ifm = 2;
         else if((pfm >=18)&&(pfm<28)) ifm = 3;
         
         if(ppm<12) ipm = 0;
         else if((ppm>=12)&&(ppm<12.7)) ipm = 1;
         else if((ppm>=12.7)&&(ppm<13.4)) ipm =2;
         else if((ppm>=13.4)&&(ppm<14.6)) ipm =3;
         else if((ppm>=14.6)&&(ppm<15.3)) ipm =4;
         else if((ppm>=15.3)&&(ppm<15.9)) ipm =5;
         else if(ppm>=15.9) ipm =6;
         
         if(pmm<4.1) imm = 0;
         else if((pmm>=4.1)&&(pmm<4.3)) imm = 1;
         else if((pmm>=4.3)&&(pmm<4.6)) imm = 2;
         else if((pmm>=4.6)&&(pmm<5.1)) imm = 3;
         else if((pmm>=5.1)&&(pmm<5.3)) imm = 4;
         else if((pmm>=5.3)&&(pmm<5.5)) imm = 5;
         else  imm = 6;*/
	}
	
    /*	m_fGradeSLM = nGrades[islm];//肌肉打分
     m_fGradeFM = nGrades[ifm];	//脂肪打分
     m_fGradePM = nGrades[ipm];	//蛋白质打分
     m_fGradeMM = nGrades[imm];	//矿物质打分*/
	dtotal = 0.1*m_fGradeSLM + 0.6*m_fGradeFM + 0.2*m_fGradePM + 0.1*m_fGradeMM; //总分
	if(dtotal>100.0) dtotal = 100;
    NSLog(@"计算前dtotal ＝ %lf",dtotal);
    dtotal = dtotal +(0.25*age - 10);
    NSLog(@"计算后dtotal ＝ %lf",dtotal);
	return dtotal;
}

+(int)calcBodyAge:(double)score age:(int)iage gender:(int)igender
{
    //m_tagTarget.score总分
    //g_personinfo.iage实际年龄
    /*
    int BodyAge=0;    //身体年龄
    if(score>80.0)
        BodyAge=(int)((double)iage/(score/80.0));
    else if(score<75.0)
        BodyAge=(int)((double)iage/(score/75.0));
    else
        BodyAge=iage;
    
//    if(BodyAge-iage>5)
//        BodyAge=iage+5;
//    else if(BodyAge-iage<-5)
//        BodyAge=iage-5;
//    else
//        BodyAge=BodyAge;
    
    if (igender) {//男
        if(BodyAge-iage>3)
            BodyAge=iage+3;
        else if(BodyAge-iage<-5)
            BodyAge=iage-5;
//        else
//            BodyAge=BodyAge;
    } else {//女
        if(BodyAge-iage>2)
            BodyAge=iage+2;
        else if(BodyAge-iage<-5)
            BodyAge=iage-5;
//        else
//            BodyAge=BodyAge;
    }
*/
    
    int BodyAge=0;
    int difference = (int)(-0.3*score+22.5);
    if (igender == 1) {//男
        if (difference < -5) {
            difference = -5;
        } else if (difference > 3){
            difference = 3;
        }
    } else {//女
        if (difference < -5) {
            difference = -5;
        } else if (difference > 2){
            difference = 2;
        }
    }
    BodyAge = iage + difference;
    NSLog(@"\nBodyAge = %d\niage = %d\ndifference = %d",BodyAge,iage,difference);
    

    return BodyAge;
    //m_tagTarget.score 是刚才得出来的评分，g_personinfo.iage是实际年龄
}
@end
