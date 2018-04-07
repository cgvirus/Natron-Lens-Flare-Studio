// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// Last_Node.frag
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/


//parametres
uniform vec3 globaltint = vec3(1.0,1.0,1.0); // Global Tint
uniform int isparalax= 0; // Parallel Flare, min=0, max=1


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    
    vec2 fxy = vec2 (1.0 - xy.x,1.0 - xy.y); //flipped
    
    vec4 linker = texture(iChannel0,xy);
    vec4 linkerflip = texture(iChannel0,fxy);
    
	if (isparalax == 1){
	fragColor = (linkerflip+linker)*vec4(globaltint,1.0);
	}
	else{
	fragColor = linker*vec4(globaltint,1.0);
	}
}
