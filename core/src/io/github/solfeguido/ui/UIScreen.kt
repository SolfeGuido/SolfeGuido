package io.github.solfeguido.ui

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.scenes.scene2d.Stage
import com.badlogic.gdx.scenes.scene2d.ui.Skin
import ktx.actors.stage
import ktx.app.KtxScreen
import ktx.inject.Context
import ktx.scene2d.KWidget
import ktx.scene2d.Scene2DSkin
import ktx.scene2d.actor

abstract class UIScreen(protected val context: Context) : KtxScreen {

    protected lateinit var stage: Stage
    private  lateinit var batch: SpriteBatch
    private val slidingTables = mutableListOf<SlidingTable>()

    override fun show() {
        super.show()
        batch = SpriteBatch()
        stage = stage(batch)
        Gdx.input.inputProcessor = stage
    }

    fun <S> KWidget<S>.slidingTable(
            align: Int,
            skin: Skin = Scene2DSkin.defaultSkin,
            init: SlidingTable.(S) -> Unit = {}) : SlidingTable {
        val act =actor(SlidingTable(align, skin), init)
        slidingTables.add(act)
        return act
    }

    override fun render(delta: Float) {
        Gdx.gl.glClearColor(1f, 1f, 1f, 0f)
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)

        stage.act(delta)
        stage.draw()

    }
}