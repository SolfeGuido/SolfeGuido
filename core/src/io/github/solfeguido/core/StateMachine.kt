package io.github.solfeguido.core

import com.badlogic.gdx.Screen
import com.badlogic.gdx.utils.ObjectMap
import ktx.app.KtxScreen
import ktx.collections.toGdxMap
import ktx.log.info
import java.lang.Exception

typealias ScreenProvider = () -> KtxScreen

class StateMachine(private val constructors : ObjectMap<Class<out KtxScreen>, ScreenProvider>, current: Class<out KtxScreen>) : Screen {
    private val stack = mutableListOf<Screen>()

    private val changes = mutableListOf<() -> Unit>()


    private fun performChanges() {
        changes.map { it.invoke() }
        changes.clear()
    }

    init {
        push(current)
    }

    private fun <Type : KtxScreen>createScreen(type: Class<Type>): KtxScreen = constructors[type]().also { it.show() }

    fun peek() = stack.last()

    fun first() = stack.first()

    fun <Type: KtxScreen> push(type: Class<Type>): StateMachine {
        changes.add {
            stack.add(createScreen(type))
        }
        return this
    }

    internal inline fun <reified  Type : KtxScreen> push() = push(Type::class.java)

    public fun pop() : StateMachine{
        changes.add {
            stack.last().hide()
            stack.last().dispose()
            stack.removeAt(stack.size - 1)
            stack.last().show()
        }
        return this
    }

    internal inline fun <reified  Type: KtxScreen>switch(): StateMachine {
        changes.add {
            hide()
            dispose()
            stack.clear()
            stack.add( createScreen(Type::class.java) )
        }
        return this
    }

    override fun hide() {
        stack.reversed().map { it.hide() }
    }

    override fun show() {
        stack.reversed().map { it.show() }
    }

    override fun render(delta: Float) {
        stack.map { it.render(delta) }
        performChanges()
    }

    override fun pause() {
        stack.map { it.pause() }
    }

    override fun resume() {
        stack.map { it.resume() }
    }

    override fun resize(width: Int, height: Int) {
        stack.map { it.resize(width, height) }
    }

    override fun dispose() {
        stack.map { it.dispose() }
    }

}