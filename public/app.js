import * as THREE from 'three'
import { EffectComposer } from 'EffectComposer'
import { ShaderPass } from 'ShaderPass'

document.addEventListener('DOMContentLoaded', init())

function init() {
    THREE.Cache.enabled = true
    const shadersLoader = new THREE.FileLoader()
    shadersLoader.setResponseType("text")
    shadersLoader.load(
        'shaders/VS.glsl',
    
        // onLoad callback
        function ( data ) {
            THREE.Cache.add("VS", data)
            loadFragmentShader()
        },
    
        // onProgress callback
        function ( xhr ) {},
    
        // onError callback
        function ( err ) {
            console.error( err )
        }
    )

    function loadFragmentShader()
    {
        shadersLoader.load(
            'shaders/FS.glsl',
        
            // onLoad callback
            function ( data ) {
                THREE.Cache.add("FS", data)
                animationInit()
            },
        
            // onProgress callback
            function ( xhr ) {},
        
            // onError callback
            function ( err ) {
                console.error( err )
            }
        )
    }


    let renderer, composer
    let VS = "", FS = ""
    let pointsCount = Math.trunc((1 - Math.random()) * 7 + 3)
    let points = []
    
    function animationInit()
    {
        VS = THREE.Cache.get("VS")
        FS = THREE.Cache.get("FS")
        FS = FS.replace("const int pointsCount = uniform int;", `const int pointsCount = ${pointsCount};`)
        
        renderer = new THREE.WebGLRenderer({
            canvas: document.getElementById('threejs'),
            antialias: true
        })
        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.setPixelRatio(window.devicePixelRatio)
        renderer.setClearColor(0x202020)

        composer = new EffectComposer(renderer)
        composer.setSize(window.innerWidth, window.innerHeight)
        composer.setPixelRatio(window.devicePixelRatio)

        for (let i = 0; i < pointsCount; i++) {
            points.push({
                position: new THREE.Vector2(Math.sin(2*Math.PI * i/pointsCount), Math.cos(2*Math.PI * i/pointsCount)),
                direction: new THREE.Vector2(0, 0),
                distance: 0.7,
                influence: 0.4,
                mustBeCloser: false,
                color: new THREE.Vector4(Math.random(), Math.random(), Math.random(), 1)
            })
        }

        const shaderProgram = {
            uniforms: {
                time: {value: 0},
                aspect: {value: window.innerWidth/window.innerHeight},
                offset: {value: new THREE.Vector2(0, 0)},
                zoom: {value: 1.5},
                points: {value: points},
                maxIterations: {value: 20}
            },
            vertexShader: VS,
            fragmentShader: FS
        }
        const shaderPass = new ShaderPass(shaderProgram)
        composer.addPass(shaderPass)

        renderer.setAnimationLoop(animation)
    }

    function animation(time)
    {
        composer.passes[0].uniforms.time.value = time
        composer.passes[0].uniforms.points.value.forEach(element => {
            element.influence = Math.abs(Math.sin(time/50000))
        });
        //[0].influence = Math.abs(Math.cos(time/5000))
        composer.render()
    }



    window.addEventListener('resize', resize)

    function resize()
    {
        composer.passes[0].uniforms.aspect.value = window.innerWidth/window.innerHeight

        composer.setSize(window.innerWidth, window.innerHeight)
        composer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    }
}