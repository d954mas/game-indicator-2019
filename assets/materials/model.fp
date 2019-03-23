varying mediump vec4 var_position;
varying mediump vec3 var_normal;
varying mediump vec2 var_texcoord0;
varying mediump vec4 var_light;

uniform lowp sampler2D tex0;
uniform lowp vec4 tint;
uniform highp vec4 line;

void main()
{
    // Pre-multiply alpha since all runtime textures already are
    vec4 tint_pm = vec4(tint.xyz * tint.w, tint.w);
    vec4 color = texture2D(tex0, var_texcoord0.xy) * tint_pm;
    if(line.x != 0 ||  line.x != 0  || line.x != 0){
  //  if (color.r == 1 && color.g == 0 && color.b == 0 && color.a == 1 ) {
        float number = line.x * var_texcoord0.x + line.y * var_texcoord0.y + line.z;
        if(number > 0){
            float x0  = var_texcoord0.x, y0 = var_texcoord0.y;
            float a = line.x, b = line.y, c = line.z;
            float x = x0 - (2 * a * (a * x0 + b*y0 + c))/(a*a + b*b);
            float y = y0 - (2 * b * (a * x0 + b*y0 + c))/(a*a + b*b);
            color = texture2D(tex0, vec2(x,y)) * tint_pm;
         //   if (color.r == 1 && color.g == 0 && color.b == 0 && color.a == 1 ) {
                gl_FragColor =  color;
           // }else{
                //discard;
          //  }
           
            
        }else{
             gl_FragColor = vec4(0,1,0,0.5);
        }
    }else{
        discard;
    }

   // }else{
    //    discard;
    //}
}

