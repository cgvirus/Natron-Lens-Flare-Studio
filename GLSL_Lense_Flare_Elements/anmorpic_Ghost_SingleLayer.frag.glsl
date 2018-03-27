// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.

//parametres
uniform int objectCount= 5; // Object Count, min=0, max=30
uniform float objectdist = 0.16; // Object Distance , min=-2.,max=2.
uniform float tapperness = 1.0; // Tapperness, min=0., max=1.
uniform float cposx = 0.0; // Position X , min=-2.,max=2.
uniform float cposy = 0.0; // Position Y , min=-2.,max=2.
uniform float sizex = .20; // Scale X , min=0., max=10.
uniform float sizey = 0.02; // Scale Y , min=-0, max=10.
uniform float rotation = 0.0; // Rotation , min=0.,max=360.
uniform float Thresold = .03; // Round Corner, min=0., max=10.
uniform float Hardness = 3.6; // Hardness, min=0.0, max=50.
uniform float parallax = -1.0; // Parallax , min=-1., max=1.
uniform vec3 Color = vec3(1.,1.,1.); // Color


const float      PI = 3.14159265359;
const float  TWO_PI = 6.28318530718;

//creates a adjustable Anamorphic spot
float circleBox(vec2 uv, vec2 pos, vec2 size, float cornerRadius, float between)
{
    vec2 main = uv-pos;
	float ang = atan(main.y, main.x);
	float dist=length(main); dist = pow(dist,.1);
	
    float rot = radians(rotation);
	mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
   	uv  = m*uv;
   	pos = m*pos;
    

    float sd = (length(uv-pos) - size.x); // circle
    size -= vec2(cornerRadius);           // rounded box
    vec2 d = (abs(uv-pos) - size);
    float box = min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - cornerRadius;
    float v = (1.0 - between)*sd + box*between;  //mix
    float f = clamp (Hardness*-v , 0.0, 1.0);
    return f;
}

float objects(vec2 uv, vec2 pos)
{
    float c = 0.0;
    for(int i=0; i<objectCount; i++){
        c+= circleBox(vec2((uv.x+cposx+(i*(objectdist-pos.x*.2))),(uv.y+cposy)), pos*-parallax, vec2(sizex,sizey)*globalSize, Thresold, tapperness);
    }
    
    return c;
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
	
	float c = objects(uv, mouse);
	fragColor = vec4(vec3(c*Color), 1)+linker;
}
