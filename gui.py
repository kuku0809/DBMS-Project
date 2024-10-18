import tkinter as tk
from tkinter import messagebox
import requests

BASE_URL = 'http://127.0.0.1:5000'

# Create Tkinter window
window = tk.Tk()
window.title("Login System")

def login():
    user_type = user_type_var.get()

    if user_type == "student":
        student_window()
    elif user_type == "management":
        management_window()
    else:
        messagebox.showerror("Error", "Please select a valid user type")

def student_window():
    # Hide login window
    window.withdraw()

    # Create new window for student
    student_win = tk.Toplevel()
    student_win.title("Student Dashboard")

    def view_details():
        srn = srn_var.get()
        response = requests.post(f"{BASE_URL}/student/view", json={"SRN": srn})
        data = response.json()

        if response.status_code == 200:
            messagebox.showinfo("Student Details", data["student"])
        else:
            messagebox.showerror("Error", data["error"])

    def check_transaction():
        srn = srn_var.get()
        response = requests.post(f"{BASE_URL}/student/transaction", json={"SRN": srn})
        data = response.json()

        if response.status_code == 200:
            messagebox.showinfo("Transaction Status", f"Status: {data['transaction_status']}, Type: {data['type_of_scholarship']}")
        else:
            messagebox.showerror("Error", data["error"])

    srn_var = tk.StringVar()
    
    tk.Label(student_win, text="Enter SRN:").pack()
    tk.Entry(student_win, textvariable=srn_var).pack()

    tk.Button(student_win, text="View Details", command=view_details).pack()
    tk.Button(student_win, text="Check Transaction Status", command=check_transaction).pack()

def management_window():
    # Hide login window
    window.withdraw()

    # Create new window for management
    management_win = tk.Toplevel()
    management_win.title("Management Dashboard")

    def view_staff():
        staff_id = staff_id_var.get()
        response = requests.post(f"{BASE_URL}/management/view_staff", json={"Staff_ID": staff_id})
        data = response.json()

        if response.status_code == 200:
            messagebox.showinfo("Staff Details", data["staff"])
        else:
            messagebox.showerror("Error", data["error"])

    def edit_student():
        edit_win = tk.Toplevel(management_win)
        edit_win.title("Edit Student Details")

        srn_var = tk.StringVar()
        name_var = tk.StringVar()
        course_var = tk.StringVar()
        year_var = tk.StringVar()
        email_var = tk.StringVar()

        tk.Label(edit_win, text="Enter SRN:").pack()
        tk.Entry(edit_win, textvariable=srn_var).pack()

        tk.Label(edit_win, text="Name:").pack()
        tk.Entry(edit_win, textvariable=name_var).pack()

        tk.Label(edit_win, text="Course:").pack()
        tk.Entry(edit_win, textvariable=course_var).pack()

        tk.Label(edit_win, text="Year:").pack()
        tk.Entry(edit_win, textvariable=year_var).pack()

        tk.Label(edit_win, text="Email:").pack()
        tk.Entry(edit_win, textvariable=email_var).pack()

        def submit_edit():
            data = {
                "SRN": srn_var.get(),
                "Name": name_var.get() or None,
                "Course": course_var.get() or None,
                "Year": year_var.get() or None,
                "Email": email_var.get() or None
            }

            response = requests.post(f"{BASE_URL}/management/edit_student", json=data)

            if response.status_code == 200:
                messagebox.showinfo("Success", "Student details updated successfully")
                edit_win.destroy()  # Close the edit window
            else:
                messagebox.showerror("Error", response.json()["error"])

        tk.Button(edit_win, text="Update Student", command=submit_edit).pack()

    staff_id_var = tk.StringVar()
    
    tk.Label(management_win, text="Enter Staff ID:").pack()
    tk.Entry(management_win, textvariable=staff_id_var).pack()
    tk.Button(management_win, text="View Staff", command=view_staff).pack()
    tk.Button(management_win, text="Edit Student Details", command=edit_student).pack()

# GUI layout for login window
user_type_var = tk.StringVar()

tk.Label(window, text="Select User Type:").pack()
tk.Radiobutton(window, text="Student", variable=user_type_var, value="student").pack()
tk.Radiobutton(window, text="Management", variable=user_type_var, value="management").pack()
tk.Button(window, text="Login", command=login).pack()

# Run the application
window.mainloop()