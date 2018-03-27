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
uniform float tapperness = 1.; // Tapperness, min=.04., max=1.
uniform float cposx = .0; // Position X , min=-2.,max=2.
uniform float cposy = .0; // Position Y , min=-2.,max=2.
uniform float sizex = 1.; // Scale X , min=0., max=10.
uniform float sizey = 0.0; // Scale Y , min=-0, max=10.
uniform float rotation = .0; // Rotation , min=0.,max=360.
uniform float Thresold = 0.5; // Thresold, min=0., max=10.
uniform float Hardness = 4.; // Hardness, min=.1, max=50.
uniform float parallax = -1.; // Parallax , min=-1., max=1.
uniform int raycount = 10; // Ray Count , min=0., max=100.
uniform float raydepth = .2; // Ray depth , min=-1.5, max=1.5
uniform vec3 Color = vec3(1.,1.,1.); // Color


const float      PI = 3.14159265359;
const float  TWO_PI = 6.28318530718;

//creates a adjustable Anamorphic spot
float circleBox(vec2 uv, vec2 pos, vec2 size, float cornerRadius, float between)
{
    vec2 main = uv-pos;
	float ang = atan(main.y, main.x);
	float dist=length(main); dist = pow(dist,.1);
	
    float rot = radians(rotation+globalRotate);
	mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
   	uv  = m*uv;
   	pos = m*pos;
    

    float sd = (length(uv-pos) - size.x); // circle
    size -= vec2(cornerRadius);           // rounded box
    vec2 d = (abs(uv-pos) - size);
    float box = min(max(d.x, d.y), 0.0) + length(max(d, 0.0)) - cornerRadius;
    float v = (1.0 - between)*sd + box*between;  //mix
    
    
    float f0 = 1.0/((length(v))*(1.0/tapperness*Hardness*100))*globalSize;
    return f0+f0*(sin((ang)*raycount)*raydepth+dist*.1+.9);
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
	
	
	float c = circleBox(vec2((uv.x+cposx),(uv.y+cposy)), mouse*-parallax, vec2(sizex,sizey)*globalSize, Thresold, tapperness);
	
	fragColor = vec4(vec3(c*Color), 1)+linker;
}
