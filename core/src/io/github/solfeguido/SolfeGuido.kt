package io.github.solfeguido

import com.badlogic.gdx.ApplicationListener
import com.badlogic.gdx.Gdx
import com.badlogic.gdx.assets.AssetManager
import io.github.solfeguido.core.SoundHelper
import io.github.solfeguido.core.StateMachine
import io.github.solfeguido.scenes.MenuScreen
import io.github.solfeguido.scenes.SplashScreen
import io.github.solfeguido.skins.getPreloadSkin
import io.github.solfeguido.utils.NoteDataPool
import ktx.collections.gdxMapOf
import ktx.inject.Context
import ktx.scene2d.Scene2DSkin

class SolfeGuido : ApplicationListener {

    private lateinit var context: Context;
    private lateinit var stateMachine: StateMachine

    override fun create() {
        context = Context()
        Scene2DSkin.defaultSkin = getPreloadSkin()

        stateMachine = StateMachine(gdxMapOf(
                MenuScreen::class.java to {MenuScreen(context)},
                SplashScreen::class.java to { SplashScreen(context) }
        ), SplashScreen::class.java)
        context.register {
            bindSingleton(NoteDataPool())
            bindSingleton(AssetManager())
            bindSingleton(SoundHelper(context))
            bindSingleton(stateMachine)
        }
    }

    override fun render() {
        stateMachine.render(Gdx.graphics.deltaTime)
    }

    override fun pause() {
        stateMachine.pause()
    }

    override fun resume() {
        stateMachine.resume()
    }

    override fun resize(width: Int, height: Int) {
        stateMachine.resize(width, height)
    }

    override fun dispose() {
        stateMachine.dispose()
    }
}