#include "na12.h"
#include <math.h>

float temp_na12=23;
float q10_na12=2.3;
float vmin_na12=-120;
float vmax_na12=100;
float tadj_na12;
float ;
float hinf,htau,minf,mtau,tadj;

void trates_na12(float v,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) ;
void rates_na12(float vm,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) ;

float trap0_na12(float v,float th,float a,float q) {
	if (fabs((v-th)/q) > 1e-6) {;
	        return  a * (v - th) / (1 - exp(-(v - th)/q));
	} else {;
	        return  a * q;
 	};
}	;

void InitModel_na12(float v,float &m,float &h,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) {
    tadj_na12 = q10_na12^((celsius - temp_na12)/10) ;
	trates_na12(v+vshift_na12,gbar_na12,vshift_na12,tha_na12,qa_na12,Ra_na12,Rb_na12,thi1_na12,thi2_na12,qi_na12,thinf_na12,qinf_na12,Rg_na12,Rd_na12);
	m = minf;
	h = hinf;
};

void trates_na12(float v,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) {
                      ;
        ;
	;
	rates_na12(v,gbar_na12,vshift_na12,tha_na12,qa_na12,Ra_na12,Rb_na12,thi1_na12,thi2_na12,qi_na12,thinf_na12,qinf_na12,Rg_na12,Rd_na12);
};

void rates_na12(float vm,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) {
float  a, b;
	a = trap0_na12(vm,tha_na12,Ra_na12,qa_na12);
	b = trap0_na12(-vm,-tha_na12,Rb_na12,qa_na12);
        tadj_na12 = q10_na12^((celsius - temp_na12)/10);
	mtau = 1/tadj_na12/(a+b);
	minf = a/(a+b);
		;
	a = trap0_na12(vm,thi1_na12,Rd_na12,qi_na12);
	b = trap0_na12(-vm,-thi2_na12,Rg_na12,qi_na12);
	htau = 1/tadj_na12/(a+b);
	hinf = 1/(1+exp((vm-thinf_na12)/qinf_na12));
};

void DerivModel_na12(float dt, float v,float &m,float &h,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) {
 {
   trates_na12 (  v + vshift_na12 ,gbar_na12,vshift_na12,tha_na12,qa_na12,Ra_na12,Rb_na12,thi1_na12,thi2_na12,qi_na12,thinf_na12,qinf_na12,Rg_na12,Rd_na12) ;
    m = m + (1. - exp(dt*(( ( ( - 1.0 ) ) ) / mtau)))*(- ( ( ( minf ) ) / mtau ) / ( ( ( ( - 1.0) ) ) / mtau ) - m) ;
    h = h + (1. - exp(dt*(( ( ( - 1.0 ) ) ) / htau)))*(- ( ( ( hinf ) ) / htau ) / ( ( ( ( - 1.0) ) ) / htau ) - h) ;
   }

void BreakpointModel_na12(MYSECONDFTYPE &sumCurrents, MYFTYPE &sumConductivity, float v,float &m,float &h,float gbar_na12,float vshift_na12,float tha_na12,float qa_na12,float Ra_na12,float Rb_na12,float thi1_na12,float thi2_na12,float qi_na12,float thinf_na12,float qinf_na12,float Rg_na12,float Rd_na12) {
gna=tadj_na12*gbar_na12*m*m*m*h;
ina=(1e-4)*gna*(v-ena);
sumCurrents+= ina;
sumConductivity+= gna;
};
