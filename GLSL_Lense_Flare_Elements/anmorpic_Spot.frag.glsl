// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// anmorpic_Spot.frag
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.

//parametres
uniform int objectCount= 5; // Object Count, min=0, max=30
uniform int intesmult= 1; // Intensity Multiplyer, min=1, max=10
uniform float objectdist = -0.2; // Object Distance , min=-2.,max=2.
uniform float tapperness = 1.0; // Tapperness, min=0., max=1.
uniform float cposx = -0.47; // Position X , min=-2.,max=2.
uniform float cposy = 0.08; // Position Y , min=-2.,max=2.
uniform float sizex = 0.32; // Scale X , min=0., max=10.
uniform float sizey = 0.02; // Scale Y , min=-0, max=10.
uniform float randomized = .33; // Randomize, min=0., max=10.
uniform float rotation = 0.0; // Rotation , min=0.,max=360.
uniform float RoundCorner = .03; // Round Corner, min=0., max=10.
uniform float intensity = 19; // Intensity, min=0.0, max=50.
uniform float brightness = 1; // Brightness, min=0.0, max=50.
uniform float parallax = -1.0; // Parallax , min=-1., max=1.
uniform vec3 BGColor = vec3(1.,1.,1.); // BGColor
uniform vec3 Color1 = vec3(1.0,0.0,1.0); // Color1
uniform vec3 Color2 = vec3(0.0,0.3,0.0); // Color2
uniform vec3 Color3 = vec3(0.1,0.0,0.6); // Color3


const float      PI = 3.14159265359;
const float  TWO_PI = 6.28318530718;

float rand(float n){
    return fract(cos(n*89.42)*343.42);
}

//creates a adjustable Anamorphic spot
vec3 circleBox(vec2 uv, vec2 pos, vec2 size, float cornerRadius, float between, vec3 color, float intens)
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
    float f = clamp (intens*-v , 0.0, 1.0);
    return f*color;
}

vec3 objects(vec2 uv, vec2 pos)
{
    vec3 c = vec3(0.0);
    for(int i=0; i<objectCount; i++){
        //Top
        c+= circleBox(vec2((uv.x+cposx+i*(objectdist-pos.x*rand(i*randomized*2.9))), (uv.y+cposy)), pos*-parallax, //position
        vec2(sizex,sizey)*globalSize*rand(i*randomized*1.9), //size
        RoundCorner, tapperness, Color1, 
        intensity*rand(i*randomized*.9));//intensity
        
        c+= circleBox(vec2((uv.x-cposx-i*(objectdist-pos.x*rand(i*randomized*5.9))), (uv.y+cposy)), pos*-parallax, //position
        vec2(sizex,sizey)*globalSize*rand(i*randomized*4.9), //size
        RoundCorner, tapperness, Color2, 
        intensity*rand(i*randomized*.5))*brightness;//intensity
        
        c+= circleBox(vec2((uv.x+cposx+i*(objectdist-pos.x*rand(i*randomized*8.9))), (uv.y+cposy)), pos*-parallax, //position
        vec2(sizex,sizey)*globalSize*rand(i*randomized*7.9), //size
        RoundCorner, tapperness, Color3, 
        intensity*rand(i*randomized*.6))*brightness;//intensity
        
        //bottom
        c+= circleBox(vec2((uv.x+cposx+i*(objectdist-pos.x*rand(i*randomized*4.9))), (uv.y+(cposy*-1))), pos*-parallax, //position
        vec2(sizex,sizey)*globalSize*rand(i*randomized*1.9), //size
        RoundCorner, tapperness, Color3, 
        intensity*rand(i*randomized*.8))*brightness;//intensity
        
        c+= circleBox(vec2((uv.x-cposx+i*(objectdist-pos.x*rand(i*randomized*5.9))), (uv.y+(cposy*-1))), pos*-parallax, //position
        vec2(sizex,sizey)*globalSize*rand(i*randomized*6.9), //size
        RoundCorner, tapperness, Color1, 
        intensity*rand(i*randomized*1.9))*(brightness*rand(i*randomized*.9));//intensity
        
        c+= circleBox(vec2((uv.x+cposx-i*(objectdist-pos.x*rand(i*randomized*2.9))), (uv.y+(cposy*-1))), pos*-parallax, //position
        vec2(sizex,sizey)*globalSize*rand(i*randomized*3.9), //size
        RoundCorner, tapperness, Color2, 
        intensity*rand(i*randomized*1.5))*(brightness*rand(i*randomized*2.9));//intensity
        
        //mid
        c+= circleBox(vec2((uv.x+0.0+i*(objectdist-pos.x*rand(i*randomized*4.9))), (uv.y+(0.0*-1))), pos*-parallax, //position
        vec2(sizex*.5,sizey*4)*globalSize*rand(i*randomized*1.9), //size
        RoundCorner*1.5, tapperness, Color3, 
        intensity*rand(i*randomized*8))*(brightness*rand(i*randomized*2.9));//intensity
        
        c+= circleBox(vec2((uv.x-0.0+i*(objectdist-pos.x*rand(i*randomized*5.9))), (uv.y+(0.0*-1))), pos*-parallax, //position
        vec2(sizex*.3,sizey*2)*globalSize*rand(i*randomized*6.9), //size
        RoundCorner*.8, tapperness, Color1, 
        intensity*rand(i*randomized*1.9));//intensity
        
        c+= circleBox(vec2((uv.x+cposx-i*(objectdist-pos.x*rand(i*randomized*2.9))), (uv.y+(0.0*-1))), pos*-parallax, //position
        vec2(sizex*.7,sizey*2)*globalSize*rand(i*randomized*10.9), //size
        RoundCorner*1.2, tapperness, Color2, 
        intensity*rand(i*randomized*.2));//intensity
        
        //mid Blur
        c+= circleBox(vec2((uv.x+0.0+i*(objectdist-pos.x*rand(i*randomized*2.9))), (uv.y+0.0)), pos*-parallax, //position
        vec2(sizex,sizey*10)*globalSize*rand(i*randomized*8.9), //size
        RoundCorner*3, tapperness, Color1,
        intensity*rand(i*randomized*0.2)*.02);//intensity
        
        c+= circleBox(vec2((uv.x+0.0-i*(objectdist-pos.x*rand(i*randomized*2.9))), (uv.y+0.0)), pos*-parallax, //position
        vec2(sizex*3,sizey*5)*globalSize*rand(i*randomized*8.9), //size
        RoundCorner*2, tapperness, Color2,
        intensity*rand(i*randomized*0.2)*.02);//intensity
        
        c+= circleBox(vec2((uv.x+0.0+i*(objectdist-pos.x*rand(i*randomized*2.9))), (uv.y+0.0)), pos*-parallax, //position
        vec2(sizex*5,sizey*8)*globalSize*rand(i*randomized*8.9), //size
        RoundCorner*5, tapperness, Color3,
        intensity*rand(i*randomized*0.2)*.01)*brightness;//intensity
        
//         //filler
//         c+= circleBox(vec2((uv.x-0.0+i*(objectdist-pos.x*rand(i*randomized*5.9))), (uv.y+0.0)), pos*-parallax, //position
//         vec2(sizex*7,sizey*10)*globalSize*rand(i*randomized*4.9), //size
//         RoundCorner, tapperness*.5, Color2, 
//         intensity*rand(i*randomized*0.1)*.02);//intensity
//         
//         c+= circleBox(vec2((uv.x+0.0+i*(objectdist-pos.x*rand(i*randomized*8.9))), (uv.y+0.0)), pos*-parallax, //position
//         vec2(sizex*10,sizey*9)*globalSize*rand(i*randomized*7.9), //size
//         RoundCorner, tapperness*.8, Color3, 
//         intensity*rand(i*randomized*0.5)*.03);//intensity
    }
    
    return c*intesmult;
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
	
	vec3 c = objects(uv, mouse);
	fragColor = vec4(c*BGColor, 1)+linker;
}
