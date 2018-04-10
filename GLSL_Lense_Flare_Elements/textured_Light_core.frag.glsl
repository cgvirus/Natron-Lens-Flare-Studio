// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0
// iChannel1: Link Texture Elements, filter=linear, wrap=clamp
// BBox: iChannel1


// Textured Light Core
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas also have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/


//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.
uniform float evolution= 1.0; // Evolution, min=1.0, max=360.

//parametres
uniform vec2 trans = vec2(-0.5,-0.5); // Offset , min=0.0, max=10.0
uniform float scaleX = 1.0; // Scale X , min=1.0, max=100.
uniform float scaleY = 1.0; // Scale Y , min=1.0, max=100.
uniform float rotation = .0; // Rotation , min=0.0, max=360.0
uniform float brightness = 1.0; // Brightness , min=1.0, max=30.0
uniform vec3 SunColor = vec3(1.,1.,1.); // Sun Color


//Procedural Sun Generation
vec4 suntex(vec2 uv, vec2 pos, float size)
{
	
	//Rotation
    float rot = radians(rotation+globalRotate)*evolution;
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;

    //Scale
    vec2 scl = 1.0/(vec2(scaleX,scaleY)*globalSize);
    mat2 s =mat2(scl.x, 0.0, 0.0, scl.y);
    uv  = s*uv;
    pos = s*pos;

    
    vec2 vector = uv-(pos+trans); //Position offsets
    vec4 sun = texture(iChannel1,vector);

	vec4 f0 = sun*brightness;
	
    
    return f0;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	
    vec4 c = suntex(uv,mouse.xy,1.);
    
    vec2 xy = (fragCoord.xy / iResolution.xy);
    vec4 linker = texture(iChannel0,xy);
	
	fragColor = (c*vec4(SunColor,1.0))+linker;
}
