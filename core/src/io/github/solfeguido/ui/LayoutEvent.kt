package io.github.solfeguido.ui

import com.badlogic.gdx.scenes.scene2d.Event
import com.badlogic.gdx.scenes.scene2d.EventListener

class LayoutEvent : Event() {}

class LayoutListener(private val handler : () -> Boolean) : EventListener {
    override fun handle(event: Event?): Boolean {
        if(event !is LayoutEvent) return false
        return handler()
    }

}