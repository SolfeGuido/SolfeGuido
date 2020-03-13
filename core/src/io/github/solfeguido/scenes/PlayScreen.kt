package io.github.solfeguido.scenes

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.ScreenAdapter
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.graphics.Pixmap
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.graphics.glutils.FrameBuffer
import com.badlogic.gdx.math.Interpolation
import com.badlogic.gdx.scenes.scene2d.InputEvent
import com.badlogic.gdx.scenes.scene2d.Stage
import com.badlogic.gdx.scenes.scene2d.actions.Actions
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener
import com.badlogic.gdx.utils.Align
import com.badlogic.gdx.utils.viewport.FitViewport
import com.badlogic.gdx.utils.viewport.Viewport
import ktx.actors.alpha
import ktx.actors.stage
import ktx.app.KtxScreen
import ktx.log.info
import ktx.scene2d.*

class PlayScreen : KtxScreen {

    private lateinit var stage: Stage
    private lateinit var batch: SpriteBatch


    override fun show() {
        Gdx.input.inputProcessor = null

        batch = SpriteBatch()


        stage = stage(batch)

        info { "Init stage" }

        val root = table {
            debug = true
            setFillParent(true)
            setPosition(0f, 0f)
            align(Align.top)
            label("SolfeGuido") {
                setPosition(this.x, this.y - this.height)
                addAction(
                        Actions.sequence(
                                Actions.delay(1f),
                                Actions.parallel(
                                        Actions.fadeOut(0.2f, Interpolation.exp10Out),
                                        Actions.moveBy(0f, -this.height, 0.2f, Interpolation.exp10Out)
                                )
                        )
                )
            }
            row()
            label("Another text")
        }
        stage.addActor(root)

        Gdx.input.inputProcessor = stage

    }

    override fun render(delta: Float) {
        Gdx.gl.glClearColor(1f, 1f, 1f, 0f)
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)

        stage.act(delta)
        stage.draw()

    }
}