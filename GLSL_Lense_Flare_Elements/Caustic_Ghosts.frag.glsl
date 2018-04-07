// iChannel0: Link GLSL Elements, filter=linear, wrap=clamp
// BBox: iChannel0

// Caustic_Ghosts.frag
/*
Implementation and Development by CGVIRUS under GNU GPL Version 3 Licence.
Some base math ideas derived from Musk's Flare https://www.shadertoy.com/view/4sX3Rs
Some math ideas also have derived from some genius minded folks and books.
Feel free to share the knowledge and any type of code contribution is encouraged.
*/

//Global parametres
uniform float globalSize = 1.0; // Global Scale, min=0., max=100.
uniform float globalRotate= 0.0; // Global Rotation, min=0., max=360.
uniform float evolution= 1.0; // Evolution, min=1.0, max=360.

//parametres
uniform float size = .5; // Size , min=0., max=10.
uniform float brightness = 1.; // Brightness , min=0., max=10.
uniform int FlareCount = 5; // Flare Count , min=0, max=50
uniform float randomized = .91; // Randomize, min=0., max=10.
uniform float BarelDistort = 1.8; // Barrel Distortion , min=0., max=10.
uniform vec3 color = vec3(1.,1.,1.); // Color



float rand(float n){
    return fract(cos(n*89.42)*343.42);
}


vec2 GetDistOffset(vec2 uv, vec2 pxoffset)
{
    vec2 tocenter = uv.xy;
    vec3 prep = normalize(vec3(tocenter.y, -tocenter.x, 0.0));
    
    float angle = length(tocenter.xy)*2.221*BarelDistort;
    vec3 oldoffset = vec3(pxoffset,0.0);
    
    vec3 rotated = oldoffset * cos(angle) + cross(prep, oldoffset) * sin(angle) + prep * dot(prep, oldoffset) * (1.0-cos(angle));
    
    return rotated.xy;
}


vec3 flare(vec2 uv, vec2 pos, float dist, float size, vec3 color)
{
    float rot = radians(globalRotate)*evolution;
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
    
    pos = GetDistOffset(uv, pos);
    
    float r = max(0.01-pow(length(uv+(dist-.05)*pos),2.4)*(1./(size*globalSize*2.)),.0)*6.0;
	float g = max(0.01-pow(length(uv+ dist     *pos),2.4)*(1./(size*globalSize*2.)),.0)*6.0;
	float b = max(0.01-pow(length(uv+(dist+.05)*pos),2.4)*(1./(size*globalSize*2.)),.0)*6.0;
    
    return vec3(r,g,b)*color;
}

vec3 orb(vec2 uv, vec2 pos, float dist, float size, vec3 color)
{
    float rot = radians(globalRotate);
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
    
    vec3 c = vec3(0.0);
    for(int i=0; i<FlareCount; i++)
    {
        float j = float(i+1);
        float offset = j/(j+1.);
        float colOffset = j/float(FlareCount*2);
        
        c += flare(uv,pos,dist+offset, size*globalSize/(j+.1), vec3(1.0-colOffset, 1.0, 0.5+colOffset));
    }
    
    c += flare(uv,pos,dist+.5, 4.0*size*globalSize, vec3(1.0))*4.0;
    
    return (c/4.0)*color;
}

vec3 ring(vec2 uv, vec2 pos, float dist)
{
    float rot = radians(globalRotate);
    mat2 m = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv  = m*uv;
    pos = m*pos;
    
    vec2 uvd = uv*(length(uv));
    
    float r = max(1.0/(1.0+32.0*pow(length(uvd+(dist-.05)*pos),2.0)),.0)*00.25;
	float g = max(1.0/(1.0+32.0*pow(length(uvd+ dist     *pos),2.0)),.0)*00.23;
	float b = max(1.0/(1.0+32.0*pow(length(uvd+(dist+.05)*pos),2.0)),.0)*00.21;
    
    return vec3(r,g,b);
}


vec3 lensflare(vec2 uv,vec2 pos, float brightness, float size)
{

    vec3 c = vec3(0.0,0.0,0.0);
    for (int i=0; i<FlareCount; i++){
    c += flare(uv,pos, rand(i*randomized),rand(i*randomized)*size*globalSize,color);
    c += flare(uv,pos, -rand(i*randomized),rand(i*randomized*5.8)*size*globalSize,color);
    }
    c += flare(uv,pos, .5,.8*size*globalSize,color);
    c += flare(uv,pos,-.4,.8*size*globalSize,color);
    
    c += orb(uv,pos, 0., .5*size*globalSize,color);
    
    c += ring(uv,pos,-1.)*.5*size*globalSize;
    c += ring(uv,pos, 1.)*.5*size*globalSize;
    
    return c*brightness;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy - 0.5;
	uv.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 mouse = vec3(iMouse.xy/iResolution.xy - 0.5,iMouse.z-.5);
	mouse.x *= iResolution.x/iResolution.y; //fix aspect ratio
	vec3 color = lensflare(uv,mouse.xy,brightness,size*globalSize);
	
    vec2 xy = fragCoord.xy / iResolution.xy;
    vec4 linker = texture(iChannel0,xy);
    
	fragColor = vec4(pow(color, vec3(1.5)),1.0)+linker;
}
