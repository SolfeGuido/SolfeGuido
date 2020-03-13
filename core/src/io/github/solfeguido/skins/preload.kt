package io.github.solfeguido.skins

import com.badlogic.gdx.assets.AssetManager
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.g2d.BitmapFont
import com.badlogic.gdx.scenes.scene2d.ui.Skin
import ktx.style.label
import ktx.style.skin
import ktx.style.textButton

fun getPreloadSkin() : Skin {
    return skin {
        label {
            font = BitmapFont()
            fontColor = Color.BLACK
        }
    }
}