package io.github.solfeguido.ui

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.math.Interpolation
import com.badlogic.gdx.scenes.scene2d.Action
import com.badlogic.gdx.scenes.scene2d.Actor
import com.badlogic.gdx.scenes.scene2d.actions.Actions
import com.badlogic.gdx.scenes.scene2d.ui.Cell
import com.badlogic.gdx.scenes.scene2d.ui.Skin
import com.badlogic.gdx.scenes.scene2d.ui.Table
import com.badlogic.gdx.utils.Align
import ktx.actors.*
import ktx.log.info
import ktx.scene2d.*



class SlidingTable(private val al: Int, skin: Skin) : Table(skin), KTable {

    private val interpolation = Interpolation.exp5Out
    private var transitionDone = false

    init {
        super.align(al)
    }

    private fun getYExit(a: Actor) : Float = when {
        Align.isTop(al) -> a.height
        Align.isBottom(al) -> -a.height
        else -> 0f
    }
    private fun getXExit(a: Actor) : Float = when {
        Align.isLeft(al) -> -a.width
        Align.isRight(al) -> a.width
        else -> 0f
    }

    private fun getEnterAnimation(a : Actor, duration: Float = 0.4f) : Action {
        return (Actions.moveBy(getXExit(a), getYExit(a)) / Actions.fadeOut(0f) ) +
                (Actions.moveTo(a.x, a.y, duration, interpolation) / Actions.fadeIn(duration, interpolation))
    }

    fun slideOut(then: Action) {
        var delay = 0f
         children!!.map {
            it +=  Actions.delay(delay) +
                   (Actions.moveBy(getXExit(it), getYExit(it), 0.4f, interpolation) / Actions.fadeOut(0.4f, interpolation)) +
                    Actions.removeActor() +
                    then
             delay += 0.1f
        }
    }

    override fun layout() {
        super.layout()
        if(!transitionDone) {
            transitionDone = true
            children!!.forEach {
                it.fire(LayoutEvent())
            }
        }
    }

    override fun <T : Actor> add(actor: T): Cell<T> {
        actor.addListener(LayoutListener {
            actor += this.getEnterAnimation(actor)
            true
        })
        return super.add(actor)
    }
}