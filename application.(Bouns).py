import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector
from mysql.connector import Error
from tkinter import filedialog
import csv

# Database connection configuration
### Please edit these config according to the credentials of the Server connection on the executing machine

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',                # Replace this password with your server user
    'password': 'merolakhalifa',   # Replace this password with your server password
    'database': 'biomedical_schema'
}

class BiomedicalApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Biomedical Research Database")
        self.root.geometry("1000x700")

        tab_control = ttk.Notebook(root)

        self.authors_tab = ttk.Frame(tab_control)
        self.research_tab = ttk.Frame(tab_control)
        self.journal_tab = ttk.Frame(tab_control)
        self.publisher_tab = ttk.Frame(tab_control)
        self.fields_tab = ttk.Frame(tab_control)

        tab_control.add(self.authors_tab, text='Authors')
        tab_control.add(self.research_tab, text='Research')
        tab_control.add(self.journal_tab, text='Journals')
        tab_control.add(self.publisher_tab, text='Publishers')
        tab_control.add(self.fields_tab, text='Fields')
        tab_control.pack(expand=1, fill='both')

        self.create_authors_tab()
        self.create_research_tab()
        self.create_journal_tab()
        self.create_publisher_tab()
        self.create_fields_tab()

    def connect_db(self):
        try:
            return mysql.connector.connect(**DB_CONFIG)
        except Error as e:
            messagebox.showerror("Database Connection Error", str(e))
            return None

    def execute_query(self, query, values=None, fetch=False):
        conn = self.connect_db()
        if not conn:
            return []
        try:
            cursor = conn.cursor()
            if values:
                cursor.execute(query, values)
            else:
                cursor.execute(query)
            data = cursor.fetchall() if fetch else None
            conn.commit()
            cursor.close()
            return data
        except Error as e:
            messagebox.showerror("Query Error", str(e))
            return []
        finally:
            conn.close()

    def create_authors_tab(self):
        ttk.Label(self.authors_tab, text="Authors", font=("Arial", 14)).pack(pady=10)
        self.authors_tree = ttk.Treeview(self.authors_tab, columns=("ID", "Name", "Qualification", "Affiliation", "Job Title", "Email", "h-index"), show='headings')
        for col in self.authors_tree['columns']:
            self.authors_tree.heading(col, text=col)
        self.authors_tree.pack(expand=True, fill='both')
        ttk.Button(self.authors_tab, text="Load Authors", command=self.load_authors).pack(pady=5)
        ttk.Button(self.authors_tab, text="Add Author", command=self.add_author).pack(pady=5)
        ttk.Button(self.authors_tab, text="Export Authors to CSV", command=self.export_authors_to_csv).pack(pady=5)

    def load_authors(self):
        rows = self.execute_query("SELECT * FROM Author", fetch=True)
        self.authors_tree.delete(*self.authors_tree.get_children())
        for row in rows:
            self.authors_tree.insert("", "end", values=row)

    def add_entity(self, title, table, fields, reload_callback):
        def submit():
            placeholders = ", ".join(["%s"] * len(variables))
            columns = ", ".join(fields)
            query = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
            values = [var.get() for var in variables]
            self.execute_query(query, values=values)
            top.destroy()
            reload_callback()

        top = tk.Toplevel(self.root)
        top.title(f"Add {title}")
        variables = [tk.StringVar() for _ in fields]

        for i, field in enumerate(fields):
            ttk.Label(top, text=field).grid(row=i, column=0, padx=10, pady=5)
            ttk.Entry(top, textvariable=variables[i]).grid(row=i, column=1, padx=10, pady=5)

        ttk.Button(top, text="Submit", command=submit).grid(row=len(fields), column=0, columnspan=2, pady=10)

    def add_author(self):
        self.add_entity("Author", "Author",
                        ["Name", "Qualification", "Affiliation", "Job_Title", "Email", "h_index"],
                        self.load_authors)

    def export_authors_to_csv(self):
        file_path = filedialog.asksaveasfilename(defaultextension=".csv", filetypes=[("CSV files", "*.csv")])
        if not file_path:
            return

        rows = self.execute_query("SELECT * FROM Author", fetch=True)
        if not rows:
            messagebox.showinfo("Export", "No data to export.")
            return

        try:
            with open(file_path, mode='w', newline='', encoding='utf-8') as file:
                writer = csv.writer(file)
                writer.writerow(["ID", "Name", "Qualification", "Affiliation", "Job Title", "Email", "h-index"])
                for row in rows:
                    writer.writerow(row)
            messagebox.showinfo("Export", f"Authors exported successfully to {file_path}")
        except Exception as e:
            messagebox.showerror("Export Error", str(e))

    def create_research_tab(self):
        ttk.Label(self.research_tab, text="Research Articles", font=("Arial", 14)).pack(pady=10)
        self.research_tree = ttk.Treeview(self.research_tab, columns=("ID", "Title", "Abstract", "Date", "Field", "Journal ISSN", "Citations", "Year"), show='headings')
        for col in self.research_tree['columns']:
            self.research_tree.heading(col, text=col)
        self.research_tree.pack(expand=True, fill='both')
        ttk.Button(self.research_tab, text="Load Research", command=self.load_research).pack(pady=5)
        ttk.Button(self.research_tab, text="Add Research", command=self.add_research).pack(pady=5)

    def load_research(self):
        rows = self.execute_query("SELECT * FROM Research", fetch=True)
        self.research_tree.delete(*self.research_tree.get_children())
        for row in rows:
            self.research_tree.insert("", "end", values=row)

    def add_research(self):
        self.add_entity("Research", "Research",
                        ["Title", "Abstract", "Date", "Field_ID", "Journal_ISSN", "Citations", "Year"],
                        self.load_research)

    def create_journal_tab(self):
        ttk.Label(self.journal_tab, text="Journals", font=("Arial", 14)).pack(pady=10)
        self.journal_tree = ttk.Treeview(self.journal_tab, columns=("ISSN", "Name", "Field", "Impact", "Quarter", "Publisher ID", "Country", "Start Date", "Rate", "Open Access"), show='headings')
        for col in self.journal_tree['columns']:
            self.journal_tree.heading(col, text=col)
        self.journal_tree.pack(expand=True, fill='both')
        ttk.Button(self.journal_tab, text="Load Journals", command=self.load_journals).pack(pady=5)
        ttk.Button(self.journal_tab, text="Add Journal", command=self.add_journal).pack(pady=5)

    def load_journals(self):
        rows = self.execute_query("SELECT * FROM Journal", fetch=True)
        self.journal_tree.delete(*self.journal_tree.get_children())
        for row in rows:
            self.journal_tree.insert("", "end", values=row)

    def add_journal(self):
        self.add_entity("Journal", "Journal",
                        ["ISSN", "Name", "Field", "Impact", "Quarter", "Publisher_ID", "Country", "Start_Date", "Rate", "Open_Access"],
                        self.load_journals)

    def create_publisher_tab(self):
        ttk.Label(self.publisher_tab, text="Publishers", font=("Arial", 14)).pack(pady=10)
        self.publisher_tree = ttk.Treeview(self.publisher_tab, columns=("ID", "Name", "Types", "Payment Methods"), show='headings')
        for col in self.publisher_tree['columns']:
            self.publisher_tree.heading(col, text=col)
        self.publisher_tree.pack(expand=True, fill='both')
        ttk.Button(self.publisher_tab, text="Load Publishers", command=self.load_publishers).pack(pady=5)
        ttk.Button(self.publisher_tab, text="Add Publisher", command=self.add_publisher).pack(pady=5)

    def load_publishers(self):
        rows = self.execute_query("SELECT * FROM Publisher", fetch=True)
        self.publisher_tree.delete(*self.publisher_tree.get_children())
        for row in rows:
            self.publisher_tree.insert("", "end", values=row)

    def add_publisher(self):
        self.add_entity("Publisher", "Publisher",
                        ["Name", "Types", "Payment_Methods"],
                        self.load_publishers)

    def create_fields_tab(self):
        ttk.Label(self.fields_tab, text="Research Fields", font=("Arial", 14)).pack(pady=10)
        self.fields_tree = ttk.Treeview(self.fields_tab, columns=("Field ID", "Field Name"), show='headings')
        for col in self.fields_tree['columns']:
            self.fields_tree.heading(col, text=col)
        self.fields_tree.pack(expand=True, fill='both')
        ttk.Button(self.fields_tab, text="Load Fields", command=self.load_fields).pack(pady=5)
        ttk.Button(self.fields_tab, text="Add Field", command=self.add_field).pack(pady=5)

    def load_fields(self):
        rows = self.execute_query("SELECT * FROM Biomedical_Research_Field", fetch=True)
        self.fields_tree.delete(*self.fields_tree.get_children())
        for row in rows:
            self.fields_tree.insert("", "end", values=row)

    def add_field(self):
        self.add_entity("Field", "Biomedical_Research_Field",
                        ["Field_ID", "Field_Name"],
                        self.load_fields)

if __name__ == '__main__':
    root = tk.Tk()
    app = BiomedicalApp(root)
    root.mainloop()
