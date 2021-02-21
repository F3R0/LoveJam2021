// Created by F3R0 @ 2021

float playerx = 0.0; //player x position
float playery= 0.0; //player y position
float playerz = 5.0; //player z position
float playerScale = 0.5;

float dropx = 0.0; //drop x position
float dropy= 2.0; //drop y position
float dropz = 5.0; //drop z position
float dropScale = 0.5;

float rcubex = 0.0; //drop x position
float rcubey= 0.0; //drop y position
float rcubez = 5.0; //drop z position

float groundx = 0.0; //player x position
float groundy = 1.0; //player y position
float groundz = 0.0; //player z position

float lightx = 0.0; //player x position
float lighty = 8.0; //player y position
float lightz = 1.0; //player z position

float normal_str = 0.01; //normal detail (Lower is better)
float displacement_str = 0.01; //displacement strength

/// SDF - Sphere

float sdSphere(vec3 p, float r) {
    float d = length(p)-r;
    return d;
}

/// SDF - Plane

float sdPlane(vec3 p) {
    float d = p.y;
    return d;
}

/// SDF - Round Box

float sdRoundBox(vec3 p, vec3 b, float r) {
  vec3 q = abs(p) - b;
  float d = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
  return d;
  
}

/// Scene

float sceneDist(vec3 p) {

    //playery = 1.0+sin(iTime*10.0);
    //playerx = sin(4.-(iTime*5.0));
    //dropx = sin(iTime*2.0)*3.;
    //float speed = 1.0;
    
    float disp = vec4(texture(iChannel1,p.xz/10.)).r; /// sample 2d
    vec3 gp = vec3(groundx,groundy+disp*0.3,groundz);
    vec3 sp1 = vec3(playerx,playery,playerz);
    vec3 sp2 = vec3(dropx,dropy,dropz);
    vec3 rp = vec3(rcubex,rcubey,rcubez);
    float sphere1 = sdSphere(p-sp1,playerScale);
    float sphere2 = sdSphere(p-sp2,dropScale);
    float plane = sdPlane(p+gp);
    //float rounds = sdRoundBox(p-rp,vec3(0.4,0.1,0.4),0.1);
    
    //return min(plane,rounds);
    
/// Smooth Minimum
float smDist = 1.4;
    
    float h1 = max( smDist-abs(sphere1-plane), 0.0 )/smDist;
    float c = min( sphere1, plane ) - h1*h1*smDist*(1.0/4.0);
    
    float h2 = max( smDist-abs(sphere2-plane), 0.0 )/smDist;
    float d = min( sphere2, plane ) - h2*h2*smDist*(1.0/4.0);
    
    float h3 = max( smDist-abs(c-d),0.0)/smDist;
    float e = min( c,d) - h3*h3*smDist*(1.0/4.0);
   
    return e;

    //return sin(c*d)/planeDist; // strange effect :)
  
}

/// Ray Marching


float RayMarch(vec3 ro, vec3 rd) {
	float dO=0.;
    
    for(int i=0; i<128; i++) {
    	vec3 p = ro + rd*dO;
        float dS = sceneDist(p);
        dO += dS;
        if(dO>128.0 || dS<0.01) break;
    }
    
    return dO;
}

/// Calculate Normals (Forward differences)

vec3 clcNormal(vec3 p) {
    float eps = 0.001;
    vec2 h = vec2(eps,0);
    return normalize( vec3(sceneDist(p+h.xyy) - sceneDist(p),
                           sceneDist(p+h.yxy) - sceneDist(p),
                           sceneDist(p+h.yyx) - sceneDist(p)));
}

/// Calculate Light

float clcLight(vec3 p) {
    vec3 lightPos = vec3(lightx,lighty,lightz);
    //lightPos.x = sin(25.+iTime)*5.;
    
    vec3 vL = normalize(lightPos-p);
    vec3 normal = clcNormal(p);
    
    float light = clamp(dot(normal,vL),0.0,1.0);
    float d = RayMarch(p+normal*0.2,vL);
    if(d<length(lightPos-p)) light*=0.5; //shadow
    
    return light;

}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    
    vec3 ro = vec3(0, 1, 0);
    vec3 rd = normalize(vec3(uv,1.0));

    float d = RayMarch(ro, rd);
    
    vec3 p = ro + rd * d;
    
    vec3 col = vec3(0);
    
    float light = clcLight(p);
    
    col = vec3(light*0.7,light*0.4, light*0.3);
    
    fragColor = vec4(col,1.0);
}