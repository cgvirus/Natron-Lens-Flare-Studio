// iChannel0: Link a Black Constant, filter=linear, wrap=clamp
// BBox: iChannel0

/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=30.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.
uniform vec3 globaltint = vec3(1.0,1.0,1.0); // Global Tint


vec3 blank(vec2 uv, vec2 pos)
{
    vec2 main = (uv+pos);
    float elBlank = globalSize+globalRotate;
    return vec3 (elBlank,main);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 c = blank(uv,mouse.xy);
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);

	fragColor = vec4(c,1.0)*vec4(vec3(0.0),1.0)+(linker*vec4(globaltint,1.0));
}
