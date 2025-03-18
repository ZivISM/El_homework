from flask import Flask, render_template, request
import subprocess
import json

app = Flask(__name__)

@app.route('/')
def index():
    try:
        # Get all request headers
        headers = dict(request.headers)
        
        # Use subprocess to run docker command directly
        result = subprocess.run(
            ['docker', 'ps', '--format', '{{json .}}'],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            raise Exception(f"Docker command failed: {result.stderr}")
            
        # Parse the JSON output
        containers = []
        for line in result.stdout.strip().split('\n'):
            if line:
                try:
                    container_data = json.loads(line)
                    containers.append({
                        'id': container_data.get('ID', '')[:12],
                        'name': container_data.get('Names', 'Unnamed'),
                        'image': container_data.get('Image', 'Unknown'),
                        'status': container_data.get('Status', 'Unknown')
                    })
                except json.JSONDecodeError:
                    continue
        
        return render_template('index.html', containers=containers, headers=headers)
    except Exception as e:
        error_message = str(e)
        return render_template('index.html', error=error_message)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True) 