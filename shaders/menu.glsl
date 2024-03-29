// Effect created by F3R0

// SDF Function codes are based on Inigo Quilez's SDF articles.
// https://www.iquilezles.org/

// Ray Marching code is based on the tutorials of @The_ArtOfCode.
// https://www.youtube.com/c/TheArtofCodeIsCool


vec4 player = vec4(3.0, 0.0, 6.0, 0.3);
vec4 sphere = vec4(0.0, 0.0, 0.0, 0.1);
uniform float iTime = 1.0;

float red = 0.7;
float green = 0.4;
float blue = 0.3;

float groundx = 0.0; 
float groundy = -1.0;
float groundz = 5.0;
vec3 groundScale = vec3(4.0,0.1,4.0);
float groundRadius = 0.025;

float lightx = 0.0;
float lighty = 8.0;
float lightz = 1.0;

float normal_intensity = 0.1; //normal detail (Lower is better)
float dispStrength = 0.2; //displacement strength
float shadow_intensity = 0.8; //normal detail (Lower is better)

vec2 iResolution = vec2(800.0, 600.0);
uniform sampler2D iChannel1;

/// Signed Distance Field Primitives

float distSphere(vec3 origin, float radius) {
    return length(origin)-radius;
}

float distPlane(vec3 origin) {
    return origin.y;
}

float distCubeRound(vec3 origin, vec3 scale, float radius) {
  vec3 quad = abs(origin) - scale;
  return length(max(quad,0.0)) + min(max(quad.x,max(quad.y,quad.z)),0.0) - radius;
}

/// Scene

float distScene(vec3 position) {

    float displacement = vec4(Texel(iChannel1, vec2(position.x/8.0,position.z/8.0+iTime/5.0))).r; /// sample 2d
    vec3 groundPos = vec3(groundx,groundy+displacement*dispStrength,groundz);

    float playerShape = distSphere(position - vec3(player.x,player.y+sin(iTime*2.0),player.z), player.w);
    float dropShape = distSphere(position - sphere.xyz, sphere.w);

    float ground = distCubeRound(position-groundPos,groundScale,groundRadius);

    float smoothingDistance = 1.;

    float x = max( smoothingDistance-abs(playerShape-ground), 0.0 )/smoothingDistance;
    float a = min( playerShape, ground ) - x*x*smoothingDistance/4.0;

    float y = max( smoothingDistance-abs(dropShape-ground), 0.0 )/smoothingDistance;
    float b = min( dropShape, ground ) - y*y*smoothingDistance/4.0;
    
    float z = max( smoothingDistance-abs(a-b),0.0)/smoothingDistance;
    return min( a,b) - z*z*smoothingDistance/4.0;
}

/// Ray Marching

float RayMarch(vec3 camPosition, vec3 ViewDirection) {

	float distanceToCam=0.;

    for(int i=0; i<128; i++) {
    	vec3 position = camPosition + distanceToCam*ViewDirection;
        float distanceToScene = distScene(position);
        distanceToCam += distanceToScene;
        if(distanceToCam>128.0 || distanceToScene<0.01) break;
    }
    
    return distanceToCam;
}

/// Calculate Normals

vec3 calculateNormals(vec3 position) {
    
    vec2 h = vec2(normal_intensity,0);
    return normalize( vec3(distScene(position+h.xyy) - distScene(position),
                           distScene(position+h.yxy) - distScene(position),
                           distScene(position+h.yyx) - distScene(position)));
}

/// Calculate Light

float calculateLight(vec3 position) {
    
    vec3 lightPosition = vec3(lightx,lighty,lightz);
    vec3 lightVector = normalize(lightPosition-position);
    vec3 normal = calculateNormals(position);
    float lightDist = RayMarch(position+normal*0.8,lightVector);
    float light = clamp(dot(normal,lightVector),0.0,1.0);
  
    if(lightDist<length(lightPosition-position)) light*=shadow_intensity;
    
    return light;
}

/// ViewMatrix
mat3 viewMatrix(vec3 eye, vec3 center, vec3 up) {

    vec3 camViewDir = normalize(center - eye);
    vec3 camRight = normalize(cross(camViewDir, up)); 
    vec3 camUp = cross(camRight, camViewDir);              
    
    return mat3(vec3(camRight),
                vec3(camUp),
                vec3(-camViewDir)
                );
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = (-1.0 * screen_coords + 0.5 * iResolution.xy) / iResolution.y;
    
    vec3 camPosition = vec3(5, 5, 4); //Camera pos
    vec3 eye = vec3(0,0,1);

    mat3 viewToWorld = viewMatrix(eye,
                                  vec3(0.0,4.0,0.0),
                                  vec3(0.0,1.0,0.0)
                                  );
                                  
    vec3 ViewDirection = viewToWorld * normalize(vec3(uv,1.0));
    float distanceToScene = RayMarch(camPosition, ViewDirection);
    vec3 position = camPosition + ViewDirection * distanceToScene;

    float light = calculateLight(position);
    return vec4(light*red,light*green,light*blue,1.0);
}