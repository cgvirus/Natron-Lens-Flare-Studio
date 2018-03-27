// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.

//parametres
uniform float Radius = .25; // Radius, min=0., max=2.
uniform int Polycount = 6; // Polycount, min=3, max=30
uniform float softness = 0.04; // Softness, min=.04., max=5.
uniform float rotation = .0; // Rotation , min=0.,max=360.
uniform vec3 Color = vec3(1.,1.,1.); // Color


const float      PI = 3.14159265359;
const float  TWO_PI = 6.28318530718;

//creates a polygon
float polygon(vec2 uv, vec2 pos, int n, float radius)
{
    float rot = radians(rotation+globalRotate);
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
    
    vec2 p = pos;
    float angle = atan(p.x, p.y) + PI;
    float r = TWO_PI / n;
    float d = cos(floor(0.5 + angle / r) * r - angle) * length(p) / (radius*globalSize);
    return smoothstep(1.0,1.0-softness,d);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	uv -= 0.5;
	uv.x *= iResolution.x / iResolution.y;
	
	vec2 mouse = iMouse.xy/iResolution.xy;
	mouse -= 0.5;
	mouse.x *= iResolution.x / iResolution.y;
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);
	
	
	float c = polygon(uv, uv-mouse, Polycount, Radius);
	
	fragColor = vec4(vec3(c*Color), 1)+linker;
}
