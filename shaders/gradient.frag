extern vec4 colorA;
extern vec4 colorB;

vec4 effect(vec4 c, Image tex, vec2 uv, vec2 sc) {
    return mix(colorA, colorB, uv.x);
}