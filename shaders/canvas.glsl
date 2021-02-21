// Simple Pixelate Shader by F3R0

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {

    vec2 uv = fragCoord/iResolution.x-0.5;

    float pxScale = 1.0;
    vec2 pxResolution = vec2(pxScale/iResolution.x, pxScale/iResolution.y); //Pixelated Resolution
    vec2 scrCoord = fragCoord.xy/iResolution.xy+pxResolution; //add pxResolution to fix image position.
    vec2 scrPos = floor(scrCoord/pxResolution)*pxResolution;

    vec4 buffer = vec4(texture(iChannel0, scrPos));
   
    fragColor = buffer;
  
    
}
  
    
}
