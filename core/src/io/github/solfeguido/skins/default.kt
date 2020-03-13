package io.github.solfeguido.skins

import com.badlogic.gdx.assets.AssetManager
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.g2d.BitmapFont
import com.badlogic.gdx.scenes.scene2d.ui.Skin
import ktx.freetype.loadFreeTypeFont
import ktx.style.button
import ktx.style.label
import ktx.style.skin
import ktx.style.textButton

fun getDefaultSkin(assetManager: AssetManager): Skin{
    return skin {
        label {
            font = assetManager.get<BitmapFont>("fonts/MarckScript.ttf")
            fontColor = Color.BLACK
        }
        label(name = "iconStyle") {
            fontColor = Color.BLACK
            font = assetManager.get<BitmapFont>("fonts/Icons.ttf")
            font.data.setScale(.5f)
        }
        textButton( name=  "iconButtonStyle") {
            fontColor = Color.BLACK
            font = assetManager.get<BitmapFont>("fonts/Icons.ttf")
        }
    }
}