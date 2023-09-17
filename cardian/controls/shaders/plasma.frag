// https://www.shadertoy.com/view/MdtSDr
#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

varying highp vec2 qt_TexCoord0;
uniform highp float time;
uniform highp vec2 ratio;
uniform lowp vec4 color;
uniform lowp vec4 secondary;

float plasma(vec2 uv, float scale, float time) {
    float v = cos(uv.x*uv.y * scale) - cos(uv.x/(0.4+uv.y) + time);
    float f = floor(v);
    float c = ceil(v);
    float r = min(pow(min(c-v, v-f) * 1.8, 0.7), 1.0);
    return r;
}

void main() {
    vec2 cntr = ratio/2.0;
    vec2 uv = qt_TexCoord0 * ratio - cntr;
    float scale = 25.0; uv.y *= 0.6;
    float r0 = plasma(uv, scale, time);
    float r1 = plasma(uv, scale * 2.0, time * 1.5 + 0.32);
    float r = r0 * r1 * 1.0 - pow(length(cntr * cntr) * 0.8, 6.0);
    gl_FragColor = mix(secondary, color, r);
}
