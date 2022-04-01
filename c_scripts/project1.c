// Project 1.c
// Cian Surlis, Ciaran Hogan
//Cordic algorithm
//This program  implements "2.16" fixed-point CORDIC 
// loops through all possible 2.16 angles between +-90
// and prints out stats at end 


#include <stdio.h>
#include <math.h>


#define ATAN_TAB_N 16

int atantable[ATAN_TAB_N] =
{
    0xC910, //atan(2^0) = 45 degrees
    0x76B2, //atan(2^-1) = 26.5651
    0x3EB7, //atan(2^-2) = 14.0362
    0x1FD6, //7.12502
    0xFFB,  //3.57633
    0x7FF,  //1.78981      
    0x400,  //0.895174
    0x200,  //0.447614
    0x100,  //0.223808
    0x80,   //0.111904
    0x40,   //0.05595
    0x20,   //0.0279765
    0x10,   //0.0139882
    0x8,    //0.0069941
    0x4,    //0.0035013
    0x2     //0.0017485
};

//global variables 
int sin_match =0; 
int sin_no_match=0;
int cos_match=0;
int cos_no_match=0;




/*
 * Function: to_fixed
 * ----------------------------
 *   Returns input as 2.16 fixed point representation 
 *
 *   x: input to be converted 
 *
 *   returns: long double input in 2.16 representation 
 */
int to_fixed(long double x){

    long double y = pow(2,16);

    return round(x*y);
}

/*
 * Function: calc_c
 * ----------------------------
 *   Returns the appropraite K constant that number of iterations 
 *
 *   iterations: number of iterations to be executed  
 *
 *   returns: K constant  
 */
double calc_k(int iterations){
    double x = 1.0, y=1.0;
    for(int i=0; i<= (iterations-1);i++){
        x *= (1.0 +y);
        y /= 4.0;
    }
    return sqrt(1.0/x);
}


/*
 * Function: to_rad
 * ----------------------------
 *   Returns degrees input in radians
 *
 *   theta: input to be converted 
 *
 *   returns: input in radians 
 */
double to_rad(int theta){
    return theta * (M_PI/180);
}


/*
 * Function: cordic_sincos()
 * ----------------------------
 *   Coridic engine all calcuations done
     here 
 *
 *   target: target angle
 *   iterations: number of iterations
 *   
 */
int cordic_sincos(int target,int iterations)
    {
        int sigma, s, c, c1, i, k,a;
        //    int *atanptr = atantable;

        k = to_fixed(calc_k(iterations));  // Initialised constant K value
        a = 51472;  // Starting Angle 45 deg
        c = k;  // Original cos value
        s = k;  // Orginal sin value
        sigma = 1; 
           
        //printf("%f\n", to_rad(theta) );
   
        //target = to_fixed(target);
        if(target<0){
           a = -51472;  // Starting Angle 45 deg
           s = -k;  // Orginal sin value
        }
 
        
        // main cordic loop
        for (i=0; i<=(iterations-1); i++)
        {
            sigma = (target - a) > 0 ? 1 : -1;

            if(sigma < 0)//undershoot
            {
                c1 = c + (s >> i);
                s = s - (c >> i);
                c = c1;
                a -= atantable[i];
            } 
            else//overshoot 
            {
                c1 = c - (s >> i);
                s = s + (c >> i);
                c = c1;
                a += atantable[i];
            }

        }


            if( c == to_fixed(cos(target/pow(2,16) ) ) ){
               cos_match++ ; 
            }
            else{
                cos_no_match++;
            }

            if( s == to_fixed(sin(target/pow(2,16) ) ) ){
               sin_match++ ; 
            }
            else{
               sin_no_match++;
            }

        return a;//return final angle
        
    }


/*
 * Function: main
 * ----------------------------
 *   Main funtion outputs the atan table, the K constant
 *   and loops through all possible inputs between +-90
 *
 *   
 */
int main()
    {    

        printf("\nK Constant : %d \n\n",to_fixed(calc_k(16))  );

        // print atan table 
        printf("\nATAN TABLE :\n\n" );

        printf("Index | atan()\n" );
        for(int i=0;i<15;i++){

            printf("%d     |  %d\n",i,atantable[i] );
        }
        printf("\n\n" );

        
        int atan_match =0;
        int atan_no_match=0;

        int tests = to_fixed(M_PI/2)*2;//number of inputs possible from pi/2 to -pi/2 in 2.16 (205888 tests)

        int i = to_fixed(M_PI/2);//+90 in 2.16 // 102955
        int i_neg = -i;//-90 in 2.16 // -102955

        
        //loop through all possible inputs 
        for(i;i>=i_neg;i--){

            cordic_sincos(i,16);

            //fianl angle exactly matches target angle
            if( cordic_sincos(i,16) == i ) {
               atan_match++ ; 
            }
            else{
               atan_no_match++;
            }

           
        }


        // print the gathered stats from our tests
        printf("sin macthing %d\n",sin_match);
        printf("sin not macthing %d\n",sin_no_match);
        printf("cos macthing %d\n",cos_match);
        printf("cos not macthing %d\n\n\n",cos_no_match);

        printf("final angles macthing %d\n",atan_match);
        printf("final angles not macthing %d\n",atan_no_match);



    }




