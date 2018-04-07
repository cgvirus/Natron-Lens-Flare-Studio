// iChannel1: Grit Texture Source, filter=linear, wrap=repeat
// BBox: iChannel1
// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// Grit_Mask.frag
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
uniform float coresize = 40.0; // Thresold , min=0.1, max=100.
uniform float threshold = .4; // Brightness , min=0., max=1..


//Cretes a circular Grit MAsk
float grit(vec2 uv, vec2 pos, float size)
{
    
    float rot = radians(globalRotate)*evolution;
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
    
    vec2 main = uv-pos;
	
	float ang = atan(main.y, main.x);
	float dist=length(main); dist = pow(dist,.1);
	
	float f0 = (threshold*globalSize)/(length(uv-pos)*(1.0/size*100)/coresize);
    
    return f0;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	float c = grit(uv,mouse.xy,1.);
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);
    vec4 gritTex = texture(iChannel1,xy);
	
	fragColor = vec4(vec3(c),1.0)*gritTex+linker;
}
