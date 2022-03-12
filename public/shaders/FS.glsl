struct Point {
    vec2 position;
    vec2 direction;

    float criticalDistance;
    float influence;

    vec4 color;
};

#define PI 3.14159265359

//set from app.js
const int pointsCount = uniform int;

uniform Point points[pointsCount];
uniform float time;
uniform int maxIterations;

varying vec2 pixelPosition;

vec2 rotate(vec2 v, float a);
float getDistance1(vec2 P, vec2 A, vec2 B);
float getDistance2(vec2 P, vec2 A, vec2 B);
float getDistance3(vec2 P, vec2 A, vec2 B);

void main()
{
    vec4 criterionMask = vec4(0.);
    vec4 iterationMask = vec4(0.);
    vec4 resultColor = vec4(0.);

    bool haveOneTruepoint = true;
    int truepointsCount = 0;
    int iteration = 0;
    
    while (haveOneTruepoint && iteration < maxIterations) {
        haveOneTruepoint = false;

        for (int i = 0; i < pointsCount; i++) {
            float distanceToPoint = distance(pixelPosition, points[i].position)

            if (length(points[i].direction) > 0.) { //line

            }
            else { //point

            }
            
            if (parameters[i] >= conditions[i]) {
                conditions[i] += pow(t, float(iteration + 2));
                mask += 1./float(pointsCount * depth);
                //resultColor = (resultColor * trueDotsCount + dotsColors[i]) / (trueDotsCount + 1.);
                oneTrue = true;
                trueDotsCount++;
            }
            else {
                conditions[i] -= pow(t, float(iteration + 2));
            }
        }

        iteration++;
    }

    for (int i = 0; i < dotsCount; i++) {
        resultColor += dotsColors[i] * conditions[i] / float(dotsCount);
    }

    //gl_FragColor = vec4(conditions[0], conditions[1], conditions[2], 1.) * (1. - mask) + vec4(1.) * mask;
    //gl_FragColor = vec4(parameters[0], parameters[1], parameters[2], 1.);
    //gl_FragColor = mask;
    gl_FragColor = resultColor * (1.-mask);
    //gl_FragColor = 1. - vec4(float(iteration)/float(depth));
}

float getDistance1(vec2 P, vec2 A, vec2 B) {
    return ((B.y - A.y) * P.x - (B.x - A.x) * P.y + B.x * A.y - B.y * A.x) / distance(A, B);
}

float getDistance2(vec2 P, vec2 A, vec2 B) {
    vec2 N = normalize(B - A);
    vec2 C = A - P;
    return length(C - dot(C, N) * N);
}

float getDistance3(vec2 P, vec2 A, vec2 B) {
    vec2 N = normalize(B - A);
    vec2 C = dot(A - P, N) * N;
    return length(C - P);
}

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}