extern vec4 colorA;
extern vec4 colorB;

vec4 effect(vec4 c, Image tex, vec2 uv, vec2 sc) {
    vec4 pixel = Texel(tex, uv);
    vec4 gradient = mix(colorA, colorB, uv.x);

    return vec4(gradient.rgb, pixel.a * gradient.a);
}