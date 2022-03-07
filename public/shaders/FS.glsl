#define PI 3.14159265359

const int dotsCount = uniform int; //set from app.js

uniform vec2 dots[dotsCount];
uniform float time;
uniform float t;
uniform int depth;

const float l = 2. * sin(PI/float(dotsCount));
const float r = cos(PI/float(dotsCount));

const vec4 bgColor = vec4(0.);
const vec4 mainColor = vec4(1.);

varying vec2 pixelPos;


void main()
{
    vec4 mask = bgColor;
    float parameters[dotsCount];
    float conditions[dotsCount];

    for (int i = 0; i < dotsCount; i++) {
        vec2 dot1 = dots[(i + dotsCount/2) % dotsCount];
        vec2 dot2 = dots[(i + dotsCount/2 + 1) % dotsCount];
        parameters[i] = ((dot2.y - dot1.y) * pixelPos.x - (dot2.x - dot1.x) * pixelPos.y + dot2.x * dot1.y - dot2.y * dot1.x) / (distance(dot1, dot2) * (r + 1.));
        conditions[i] = t;
    }

    bool oneTrue = true;
    int iteration = 0;

    while (oneTrue && iteration < depth) {
        oneTrue = false;
        for (int i = 0; i < dotsCount; i++) {
            if (parameters[i] >= conditions[i]) {
                conditions[i] += pow(t, float(iteration + 2));
                mask += 1./float(dotsCount * depth);
                oneTrue = true;
            }
            else {
                conditions[i] -= pow(t, float(iteration + 2));
            }
        }
        iteration++;
    }

    
    

    gl_FragColor = vec4(conditions[0], conditions[1], conditions[2], 1.) * mask + vec4(1.) * (1. - mask);
    //gl_FragColor = mix(vec4(conditions[0], conditions[1], conditions[2], 1.), vec4(parameters[0], parameters[1], parameters[2], 1.), 0.5);
    //gl_FragColor = color;
}