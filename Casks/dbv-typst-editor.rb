cask "dbv-typst-editor" do
  version "0.12.1"

  on_macos do
    sha256 "49ebab5c7f677d3f665ee7099b9285247a7b06c7479fe0e713e4991c68264e97"

    url "https://github.com/davidbuenov/dbv-typst-editor/releases/download/v#{version}/DBV.Typst.Editor_#{version}_universal.dmg"

    app "DBV Typst Editor.app"

    # Comando `typs` para quien vive en la consola: `typs`, `typs fichero.typ`,
    # `typs carpeta/`. `open -a` devuelve el control al terminal en cuanto se
    # abre la ventana (lanzar el ejecutable interno lo dejaría bloqueado).
    # `command_wrapper` escribe el script y lo enlaza como `binary`; sustituye al
    # bloque `preflight`, obsoleto desde Homebrew 7.
    command_wrapper "typs", content: <<~SH
      #!/bin/sh
      exec open -a "DBV Typst Editor" "$@"
    SH

    zap trash: [
      "~/Library/Application Support/com.davidbuenov.dbv-typst-editor",
      "~/Library/Caches/com.davidbuenov.dbv-typst-editor",
      "~/Library/Saved Application State/com.davidbuenov.dbv-typst-editor.savedState",
      "~/Library/WebKit/com.davidbuenov.dbv-typst-editor",
    ]
  end

  on_linux do
    # El único AppImage que publica el proyecto es x86_64.
    depends_on arch: :x86_64

    sha256 "0ec47f9e4e81b9fa6a2982163454e3876e0ae4a28abcfe52d5bb6e24c2fab4a6"

    url "https://github.com/davidbuenov/dbv-typst-editor/releases/download/v#{version}/DBV.Typst.Editor_#{version}_amd64.AppImage"

    # Destino sin versión: así el propio actualizador o `brew upgrade` lo
    # sobrescriben en su sitio en vez de dejar un enlace por cada versión.
    app_image "DBV.Typst.Editor_#{version}_amd64.AppImage",
              target: "DBV-Typst-Editor.AppImage"

    # Comando `typs` (ver el bloque de macOS). Lanza el AppImage en segundo plano
    # para liberar el terminal; la aplicación resuelve las rutas relativas contra
    # el directorio de quien la invoca, así que no hace falta absolutizarlas aquí.
    # Desde Homebrew 7, `app_image` MUEVE el AppImage a `appimagedir` (por
    # defecto ~/Applications) y le da permiso de ejecución él mismo: el script
    # apunta allí, no a `staged_path`. El DSL no expone `appimagedir`, así que se
    # usa el valor por defecto y, si no está, se dice con claridad.
    command_wrapper "typs", content: <<~SH
      #!/bin/sh
      APPIMAGE="$HOME/Applications/DBV-Typst-Editor.AppImage"
      if [ ! -x "$APPIMAGE" ]; then
        echo "typs: $APPIMAGE not found (installed with a custom --appimagedir?)" >&2
        exit 1
      fi
      nohup "$APPIMAGE" "$@" >/dev/null 2>&1 &
    SH

    zap trash: [
      "~/.cache/com.davidbuenov.dbv-typst-editor",
      "~/.config/com.davidbuenov.dbv-typst-editor",
      "~/.local/share/com.davidbuenov.dbv-typst-editor",
    ]
  end

  name "DBV Typst Editor"
  desc "Native, fast Typst editor with live preview, built with Rust + Tauri v2"
  homepage "https://github.com/davidbuenov/dbv-typst-editor"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
end
