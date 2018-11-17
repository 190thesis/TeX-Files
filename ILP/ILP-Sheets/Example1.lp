/* Objective function */
min:x1+x2+x3+x4+x5+x6+x7+x8+x9+x10;

A1+B1=1;
A2+B2=1;
A3+B3=1;
A4+B4=1;
A5+B5=1;
A6+B6=1;
A7+B7=1;
A8+B8=1;
A9+B9=1;

A1+A2+A3+A4+3 x1>=3;
B1+x2>=1;
B2+x3>=1;
B3+A5+x4>=1;
B5+A6+2 x5>=2;
B6+A7+x6>=1;
B4+A8+A9+2 x7>=2;
B8 + x8>=1;
B9 + x9>=1;
B7 + x10>1;

bin x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,A1,A2,A3,A4,A5,A6,A7,A8,A9,B1,B2,B3,B4,B5,B6,B7,B8,B9;