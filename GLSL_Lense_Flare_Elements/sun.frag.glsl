// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// sun.frag
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some base math ideas derived from Musk's Flare https://www.shadertoy.com/view/4sX3Rs
Some math ideas also have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/


//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.
uniform float evolution= 1.0; // Evolution, min=1.0, max=360.

//parametres
uniform float coresize = 2.; // Sun Core Size , min=0., max=100.
uniform int raycount = 0; // Ray Count , min=0., max=100.
uniform float raydepth = .2; // Ray depth , min=-1.5, max=1.5
uniform float rotation = .0; // Rotation , min=0.,max=360.
uniform vec3 SunColor = vec3(1.,1.,1.); // Sun Color


//Procedural Sun Generation
float sun(vec2 uv, vec2 pos, float size)
{
    float rot = radians(rotation+globalRotate)*evolution;
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
    
    vec2 vector = uv-pos;
	
	float angle = atan(vector.y, vector.x);
	float dist=length(vector); dist = pow(dist,.1);
	
	float f0 = 1.0/(length(uv-pos)*(1.0/size*100)/(coresize*globalSize));
	
    
    return f0+f0*(sin((angle)*raycount)*raydepth+dist*.1+.9);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	float c = sun(uv,mouse.xy,1.);
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);
	
	fragColor = vec4(c*SunColor,1.0)+linker;
}
