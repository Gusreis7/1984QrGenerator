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


@app.route("/health", methods=["GET"])
def check_health():
    return {"status": "ok"}, 200


@app.route("/health/qr", methods=["GET"])
def check_qr():
    try:
        img = qrcode.make("eu sou o milhor")
        buffer = io.BytesIO()
        img.save(buffer, format="PNG")
        return "", 204
    except:
        return "", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
