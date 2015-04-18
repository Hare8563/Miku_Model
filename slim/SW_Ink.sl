////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
#define vsnoise(x) (2*(vector noise(x))-1)

vector 
vfBm(point p; uniform float octaves, lacunarity, gain)
{
	uniform float amp = 1;
	varying point pp = p;
	varying vector sum = 0;

	uniform float i;
	
	for (i=0; i<octaves; i+=1){
		sum += amp * vsnoise(pp);
		amp *= gain; pp*=lacunarity;
	}
	return sum;
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
surface ink(float 	inkwidth = 0.2, lineFreq = 10, Jitter = 10, U_Switch = 1, V_Switch = 1;
			color 	U_Color = 0, V_Color = 0;
			float 	taperwidth = 0.3,
					rotateU = 0,
					rotateV = 0,
		  			Ka = 0.2, Kd = 0.8, Ks = 0.6, 
					roughness = 0.1,
					Dots = 0;)
{
point PP;
float a, b, c, d, e, f, x, y, z;
float dist, dist1, detail, width;
float Spec_Illumination;
float which, Highpoints, taper;
color white = 1, ColorU, ColorV;

///////////////////////////////////////////////////////////////////

normal Nf = faceforward(normalize(N), I);
vector V = -normalize(I);

//////////////////////////////////////////////////////////////////

PP = transform("shader", P);
if (Dots == 1){
	PP = PP + (P + 0.2 * vfBm(2*P, 4, 2, Jitter));
}else{
 PP = PP + point noise (PP * Jitter) * 0.02; 
}
/////////////////////////////////////////////////////////////////

x = xcomp(PP);
y = ycomp(PP);


/////////////////////////////////////////////////////////////////

Spec_Illumination = comp( Oi * white * (Ka * ambient() + Kd * 
				diffuse(Nf)) + Ks * specular(Nf, V, roughness)
				, 0);
			
////////////////////////////////////////////////////////////////

Oi = Os;
Ci = color(1,1,1);

///////////////////////////////////////////////////////////////
/////////////////////////////U Lines//////////////////////////
//////////////////////////////////////////////////////////////
a = rotateU;
b = U_Switch;


dist = abs(a*x+b*y)/sqrt(a*a+b*b);


dist =dist * lineFreq;
which = mod(floor(dist), 2);
dist -= floor(dist);
	
	Highpoints =  1 * pow(0.5, which);
	taper = taperwidth * pow(0.5, which);
	
	
		width = inkwidth;
		width = width * (1-smoothstep(Highpoints-taper/2, Highpoints+taper/2, Spec_Illumination));
	
	dist = smoothstep( 0, width*0.25, dist) - smoothstep( width, width*1.25, dist);
	Ci = mix( Ci, U_Color, dist);
////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

	d = V_Switch;
	e = rotateV;
	
	
	dist1 = abs(d*x+e*y)/sqrt(d*d+e*e);

	dist1 =dist1 * lineFreq;
	which = mod(floor(dist1), 2);
	dist1 -= floor(dist1);

		Highpoints =  1 * pow(0.5, which);
		taper = taperwidth * pow(0.5, which);
			width = inkwidth;
			width = width * (1-smoothstep(Highpoints-taper/2, Highpoints+taper/2, Spec_Illumination));
	
	dist1 = smoothstep( 0, width*0.25, dist1) - smoothstep( width, width*1.25, dist1);
	Ci = mix( Ci, V_Color, dist1);
}
