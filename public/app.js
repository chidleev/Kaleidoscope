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
    let dotsCount = 3
    let dotsData = []
    
    function animationInit()
    {
        VS = THREE.Cache.get("VS")
        FS = THREE.Cache.get("FS")
        FS = FS.replace("const int dotsCount = uniform int;", `const int dotsCount = ${dotsCount};`)
        
        renderer = new THREE.WebGLRenderer({
            canvas: document.getElementById('threejs'),
            antialias: true
        })
        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
        renderer.setClearColor(0x202020)

        composer = new EffectComposer(renderer)
        composer.setSize(window.innerWidth, window.innerHeight)
        composer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

        for (let i = 0; i < dotsCount; i++) {
            dotsData.push(new THREE.Vector2(Math.sin(2*Math.PI * i/dotsCount), Math.cos(2*Math.PI * i/dotsCount)))
        }
        console.log(dotsData)

        const shaderProgram = {
            uniforms: {
                time: {value: 0},
                XScale: {value: window.innerWidth/window.innerHeight},
                offset: {value: new THREE.Vector2(0, 0)},
                zoom: {value: 4},
                dots: {value: dotsData},
                depth: {value: 25},
                t: {value: 0}
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
        composer.passes[0].uniforms.t.value = (1 + Math.cos(time/10000))/2
        composer.render()
    }



    window.addEventListener('resize', resize)

    function resize()
    {
        composer.passes[0].uniforms.XScale.value = window.innerWidth/window.innerHeight

        composer.setSize(window.innerWidth, window.innerHeight)
        composer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    }
}