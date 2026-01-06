from flask import Flask, request, send_file, abort, render_template
import qrcode
import io

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/generate_qr", methods=["POST"])
def generate_qr():
    data = request.json
    if not data or "url" not in data:
        abort(400, "Campo 'url' é obrigatório")

    img = qrcode.make(data["url"])
    buffer = io.BytesIO()
    img.save(buffer, format="PNG")
    buffer.seek(0)

    return send_file(buffer, mimetype="image/png")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
