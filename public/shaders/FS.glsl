struct Point {
    vec2 position;
    vec2 direction;

    float distance;
    float influence;

    bool mustBeCloser;

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
/*float getDistance1(vec2 P, vec2 A, vec2 B);
float getDistance2(vec2 P, vec2 A, vec2 B);
float getDistance3(vec2 P, vec2 A, vec2 B);*/

void main()
{
    vec4 resultColor = vec4(0.);

    float criticalDistance[pointsCount];
    for (int i = 0; i < pointsCount; i++) {
        criticalDistance[i] = points[i].distance * points[i].influence;
    }

    bool haveOneTruePoint = true;
    int truePointsCount = 0;
    int iteration = 0;
    
    while (haveOneTruePoint && iteration < maxIterations) {
        haveOneTruePoint = false;
        
        for (int i = 0; i < pointsCount; i++) {
            if (length(points[i].direction) > 0.) { //like line
                float distanceToPoint = distance(pixelPosition, points[i].position);
            }
            else { //like point
                float distanceToPoint = distance(pixelPosition, points[i].position);
                if (distanceToPoint >= criticalDistance[i]) {
                    if (!points[i].mustBeCloser) {
                        haveOneTruePoint = true;
                        truePointsCount++;
                        resultColor += points[i].color;
                    }
                    criticalDistance[i] += criticalDistance[i] * pow(points[i].influence, float(iteration + 1));
                }
                else {
                    if (points[i].mustBeCloser) {
                        haveOneTruePoint = true;
                        truePointsCount++;
                        resultColor += points[i].color;
                    }
                    criticalDistance[i] -= criticalDistance[i] * pow(points[i].influence, float(iteration + 1));
                }
            }
        }

        iteration++;
    }

    vec4 criterionMask = vec4(float(truePointsCount) / float(pointsCount * maxIterations));
    vec4 iterationMask = vec4(float(iteration) / float(maxIterations));
    resultColor /= float(truePointsCount);


    gl_FragColor = resultColor * (1.-criterionMask);
}

/*float getDistance1(vec2 P, vec2 A, vec2 B) {
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
}*/

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}