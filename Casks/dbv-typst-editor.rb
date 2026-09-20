cask "dbv-typst-editor" do
  version "0.9.0"

  on_macos do
    sha256 "cad31180c2e56f7daed4d69a9adc63731f9a4ba078888e373a94a1a6c44b3d30"

    url "https://github.com/davidbuenov/dbv-typst-editor/releases/download/v#{version}/DBV.Typst.Editor_#{version}_universal.dmg"

    app "DBV Typst Editor.app"

    # Comando `typs` para quien vive en la consola: `typs`, `typs fichero.typ`,
    # `typs carpeta/`. `open -a` devuelve el control al terminal en cuanto se
    # abre la ventana (lanzar el ejecutable interno lo dejaría bloqueado).
    preflight do
      File.write("#{staged_path}/typs", <<~SH)
        #!/bin/sh
        exec open -a "DBV Typst Editor" "$@"
      SH
      FileUtils.chmod 0755, "#{staged_path}/typs"
    end

    binary "#{staged_path}/typs"

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

    sha256 "fdb2d50b61fc3d91192909a53f6c7ca38f147020be0824908f425d067ca5fce2"

    url "https://github.com/davidbuenov/dbv-typst-editor/releases/download/v#{version}/DBV.Typst.Editor_#{version}_amd64.AppImage"

    # Destino sin versión: así el propio actualizador o `brew upgrade` lo
    # sobrescriben en su sitio en vez de dejar un enlace por cada versión.
    app_image "DBV.Typst.Editor_#{version}_amd64.AppImage",
              target: "DBV-Typst-Editor.AppImage"

    # Comando `typs` (ver el bloque de macOS). Lanza el AppImage en segundo plano
    # para liberar el terminal; la aplicación resuelve las rutas relativas contra
    # el directorio de quien la invoca, así que no hace falta absolutizarlas aquí.
    preflight do
      appimage = "#{staged_path}/DBV.Typst.Editor_#{version}_amd64.AppImage"
      FileUtils.chmod 0755, appimage
      File.write("#{staged_path}/typs", <<~SH)
        #!/bin/sh
        nohup "#{appimage}" "$@" >/dev/null 2>&1 &
      SH
      FileUtils.chmod 0755, "#{staged_path}/typs"
    end

    binary "#{staged_path}/typs"

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
