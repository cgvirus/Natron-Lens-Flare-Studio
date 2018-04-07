// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// MulitiIris Multi Layer.frag
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some math ideas have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.
uniform float evolution= 1.0; // Evolution, min=1.0, max=360.

//multi_iris Params
uniform int corpoly = 0; // Circle/Polygon, min=0, max=1
uniform int Polycount = 6; // Polycount, min=3, max=30
uniform int MIrisAmount = 10; // MIris Ammount, min=0, max=100.
uniform float MIrisDistance = .3; // MIris Distance, min=-5., max=5.
uniform float MIrisSize = 2.0; // MIris Size, min=0., max=10.
uniform float randomized = .33; // Randomize, min=0., max=10.
uniform float MIrisPosition = -1.5; // MIris Position, min=-10., max=1.
uniform float MIrisOpacity = 2.; // MIris Opacity, min=0., max=10.
uniform float brightness = 1.4; // Brightness, min=0., max=10.
uniform vec3 MIrisColor1 = vec3(.7,.8,1.); // MIris Color 1
uniform vec3 MIrisColor2 = vec3(.7,.8,1.); // MIris Color 2
uniform vec3 MIrisColor3 = vec3(.7,.8,1.); // MIris Color 3


const float      PI = 3.14159265359;
const float  TWO_PI = 6.28318530718;


float rand(float n){
    return fract(cos(n*89.42)*343.42);
}

//multi_iris Objects
vec3 miris(vec2 uv, vec2 pos, float dist, float size, float irisize, int n, float irisopacity, vec3 iriscolor)
{
    float rot = radians(globalRotate)*evolution;
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
   
   if (corpoly == 0){
        float r = max(0.01-pow(length(uv+(dist)*pos),1.*irisize)*(1./(size*irisize)),.0)*irisopacity;
        float g = max(0.01-pow(length(uv+(dist)*pos),1.*irisize)*(1./(size*irisize)),.0)*irisopacity;
        float b = max(0.01-pow(length(uv+(dist)*pos),1.*irisize)*(1./(size*irisize)),.0)*irisopacity;
    
        return vec3(r,g,b)*iriscolor;}
    
    else{
        vec2 p = uv+(dist)*pos;
        float angle = atan(p.x, p.y) + PI;
        float r = TWO_PI / n;
        float d = cos(floor(0.5 + angle / r) * r - angle) * length(p) / (size*(irisize*.04));
        
        return vec3(smoothstep(1.0,.1,d)*irisopacity*.01)*iriscolor;}
    
}


vec3 lensflare(vec2 uv,vec2 pos, float b, float size)
{
    
    vec3 c = vec3(0.0,0.0,0.0);
    
    for (int i=0; i<MIrisAmount; i++){
        c+= miris(uv, pos, MIrisDistance*i+rand(i*randomized*8.9)+MIrisPosition, size*rand(i+randomized*2.5)*5.24, MIrisSize*globalSize, Polycount,  MIrisOpacity*0.8, MIrisColor1);
        c+= miris(uv, pos, MIrisDistance*i+rand(i*randomized*5.6)+MIrisPosition, size*rand(i+randomized*4.5)*3.78, MIrisSize*globalSize, Polycount, MIrisOpacity*1.2, MIrisColor3);
        c+= miris(uv, pos, MIrisDistance*i+rand(i*randomized*7.9)+MIrisPosition, size*rand(i+randomized*1.5)*1.33, MIrisSize*globalSize, Polycount, MIrisOpacity, MIrisColor2);
        c+= miris(uv, pos, MIrisDistance*i+rand(i*randomized*2.3)+MIrisPosition, size*rand(i+randomized*7.8)*0.56, MIrisSize*globalSize, Polycount, MIrisOpacity*1.5, MIrisColor1);
    }

    return c*b;
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
	
	vec3 c = lensflare(uv,mouse,brightness,1.);
	
	fragColor = vec4(c, 1)+linker;
}









