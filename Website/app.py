from flask import Flask, request, render_template
import psycopg2
import psycopg2.extras

app = Flask(__name__)


database_host = "localhost"
database_name = "superstore"
user = "postgres"
password = "qwerty"

#Making a connection to local pg admin using psycopg2
conn = psycopg2.connect(dbname = database_name, user = user, password = password, host = database_host)

@app.route('/', methods=['GET', 'POST'])


def home():
    if request.method == 'POST':
        query = request.form['query']
        results, columns = run_query(query)
        return render_template('index.html', results=results, columns=columns, query=query)
    else:
        return render_template('index.html')

def run_query(query):
    with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        cur.execute(query)
        conn.commit()
        return cur.fetchall(), [desc[0] for desc in cur.description]

if __name__ == '__main__':
    app.run(debug=True,port = 5000)
