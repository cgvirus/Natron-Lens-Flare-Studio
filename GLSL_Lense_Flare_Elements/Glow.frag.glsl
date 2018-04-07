// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// Glow.frag
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/


//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.
uniform float evolution= 1.0; // Evolution, min=1.0, max=360.

//parametres
uniform float coresize = 0.10; // Core Size , min=0.0, max=10.
uniform float decay = 0.10; // Decay , min=.1,max=10.
uniform vec3 FColor = vec3(1.0,1.0,1.0); // Color


//Procedural Flare Generation
float glow(vec2 uv, vec2 pos, float size)
{
    float rot = radians(globalRotate)*evolution;
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;

    vec2 main = uv-pos;

    float ang = atan(main.y, main.x);
    float dist=length(main); dist = pow(dist,.1);


    float f0 = 1./(length(main*decay)*(1.0/size*100)/(coresize*globalSize));
    return f0;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	float c = glow(uv,mouse.xy,1.);
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);
	
	fragColor = vec4(c*FColor,1.0)+linker;
}
