from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import bcrypt

app = Flask(__name__)
# CORS(app)
CORS(app, resources={r"/*": {"origins": "*"}})


# Database connection
def get_db_connection():
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='Kuku0809',
        database='university_scholarship'
    )
    return connection


# API to validate login@app.route('/login', methods=['POST'])
@app.route('/login', methods=['POST'])
def login():
    if request.method == 'OPTIONS':
        return jsonify({'status': 'OK'}), 200

    username = request.json.get('username')
    password = request.json.get('password')
    user_type = request.json.get('user_type')

    if not username or not password or not user_type:
        return jsonify({'error': 'Username, password, and user type are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Validate based on user_type
    if user_type == 'student':
        # Query to validate student login
        cursor.execute("SELECT SRN, password FROM Students WHERE SRN = %s", (username,))
        student = cursor.fetchone()

        if student and student['password'] == password:  # Add password hash check if needed
            return jsonify({'message': 'Student logged in'}), 200
        else:
            return jsonify({'error': 'Invalid username or password'}), 401



    elif user_type == 'management':
        # Query to validate staff login
        cursor.execute("SELECT Staff_ID, password FROM staff WHERE Staff_ID = %s", (username,))
        staff = cursor.fetchone()

        if staff and staff['password'] == password:
            return jsonify({'message': 'Staff logged in'}), 200
        else:
            return jsonify({'error': 'Invalid username or password'}), 401

    else:
        return jsonify({'error': 'Invalid user type'}), 400

    cursor.close()
    conn.close()


# API to change student password
@app.route('/student/change_password', methods=['POST'])
def change_student_password():
    data = request.json
    SRN = data.get('SRN')
    current_password = data.get('current_password')
    new_password = data.get('new_password')

    if not SRN or not current_password or not new_password:
        return jsonify({'error': 'SRN, current password, and new password are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    # Validate current password
    cursor.execute("SELECT password FROM Students WHERE SRN = %s", (SRN,))
    student = cursor.fetchone()

    if student and student[0] == current_password:
        cursor.execute("UPDATE Students SET password = %s WHERE SRN = %s", (new_password, SRN))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Password changed successfully'}), 200
    else:
        cursor.close()
        conn.close()
        return jsonify({'error': 'Current password is incorrect'}), 401


# API to change management password
@app.route('/management/change_password', methods=['POST'])
def change_management_password():
    data = request.json
    Staff_ID = data.get('Staff_ID')
    current_password = data.get('current_password')
    new_password = data.get('new_password')

    if not Staff_ID or not current_password or not new_password:
        return jsonify({'error': 'Staff ID, current password, and new password are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    # Validate current password
    cursor.execute("SELECT password FROM staff WHERE Staff_ID = %s", (Staff_ID,))
    staff = cursor.fetchone()

    if staff and staff[0] == current_password:
        cursor.execute("UPDATE staff SET password = %s WHERE Staff_ID = %s", (new_password, Staff_ID))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({'message': 'Password changed successfully'}), 200
    else:
        cursor.close()
        conn.close()
        return jsonify({'error': 'Current password is incorrect'}), 401


# API to view student details
@app.route('/student/view', methods=['POST'])
def view_student_details():
    SRN = request.json.get('SRN')
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM students WHERE SRN=%s", (SRN,))
    student = cursor.fetchone()
    connection.close()
    if student:
        return jsonify({'student': student}), 200
    else:
        return jsonify({'error': 'Student not found'}), 404


# API to check transaction status
@app.route('/student/transaction', methods=['POST'])  # Added route decorator
def check_transaction_status():
    SRN = request.json.get('SRN')
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT Transaction_Status, Type_of_Scholarship FROM Status WHERE SRN=%s", (SRN,))

    transaction = cursor.fetchone()
    connection.close()

    if transaction:
        return jsonify({
            'transaction_status': transaction[0],
            'type_of_scholarship': transaction[1]
        }), 200
    else:
        return jsonify({'error': 'No transactions found for this SRN'}), 404


# API to view staff details
@app.route('/management/view_staff', methods=['POST'])
def view_staff_details():
    Staff_ID = request.json.get('Staff_ID')
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Staff WHERE Staff_ID=%s", (Staff_ID,))
    staff = cursor.fetchone()
    connection.close()
    if staff:
        return jsonify({'staff': staff}), 200
    else:
        return jsonify({'error': 'Staff not found'}), 404


# API to edit student details
@app.route('/management/edit_student', methods=['POST'])
def edit_student_details():
    data = request.json
    SRN = data.get('SRN')

    if not SRN:
        return jsonify({'error': 'SRN is required'}), 400

    # Building the SQL query dynamically to update only the provided fields
    fields_to_update = []
    values = []

    if 'Name' in data:
        fields_to_update.append("Name=%s")
        values.append(data['Name'])

    if 'Semester' in data:
        fields_to_update.append("Semester=%s")
        values.append(data['Semester'])

    if 'Section' in data:
        fields_to_update.append("Section=%s")
        values.append(data['Section'])

    if 'Branch' in data:
        fields_to_update.append("Branch=%s")
        values.append(data['Branch'])

    if 'Gender' in data:
        fields_to_update.append("Gender=%s")
        values.append(data['Gender'])

    if 'Date_of_Birth' in data:
        fields_to_update.append("Date_of_Birth=%s")
        values.append(data['Date_of_Birth'])

    if 'Street' in data:
        fields_to_update.append("Street=%s")
        values.append(data['Street'])

    if 'City' in data:
        fields_to_update.append("City=%s")
        values.append(data['City'])

    if 'State' in data:
        fields_to_update.append("State=%s")
        values.append(data['State'])

    if 'CGPA' in data:
        fields_to_update.append("CGPA=%s")
        values.append(data['CGPA'])

    if 'SGPA' in data:
        fields_to_update.append("SGPA=%s")
        values.append(data['SGPA'])

    if 'Credits_received' in data:
        fields_to_update.append("Credits_received=%s")
        values.append(data['Credits_received'])

    if 'Credits_required' in data:
        fields_to_update.append("Credits_required=%s")
        values.append(data['Credits_required'])

    if 'Account_number' in data:
        fields_to_update.append("Account_number=%s")
        values.append(data['Account_number'])

    if 'IFSC_code' in data:
        fields_to_update.append("IFSC_code=%s")
        values.append(data['IFSC_code'])

    if 'Fee_category' in data:
        fields_to_update.append("Fee_category=%s")
        values.append(data['Fee_category'])

    if 'Fee_amount' in data:
        fields_to_update.append("Fee_amount=%s")
        values.append(data['Fee_amount'])

    if 'Payment_status' in data:
        fields_to_update.append("Payment_status=%s")
        values.append(data['Payment_status'])

    if 'Eligibility' in data:
        fields_to_update.append("Eligibility=%s")
        values.append(data['Eligibility'])

    # If there are fields to update, proceed
    if fields_to_update:
        query = f"UPDATE Students SET {', '.join(fields_to_update)} WHERE SRN=%s"
        values.append(SRN)

        # Execute the update query
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute(query, tuple(values))
        connection.commit()
        connection.close()

        return jsonify({'message': 'Student details updated successfully'}), 200
    else:
        return jsonify({'error': 'No fields to update'}), 400


@app.route('/management/edit_transaction', methods=['POST'])
def edit_transaction_status():
    data = request.json
    SRN = data.get('SRN')
    Name = data.get('Name')
    status = data.get('status')
    if not SRN or not Name or not status:
        return jsonify({'error': 'SRN, Name, and status are required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        UPDATE Status 
        SET Transaction_Status=%s 
        WHERE SRN=%s AND Name=%s
    """, (status, SRN, Name))
    connection.commit()
    connection.close()

    return jsonify({'message': 'Transaction status updated successfully'}), 200


if __name__ == '__main__':
    app.run(debug=True)




# from flask import Flask, request, jsonify
# from flask_cors import CORS
# import mysql.connector

# app = Flask(__name__)
# CORS(app) 

# # Database connection
# def get_db_connection():
#     connection = mysql.connector.connect(
#         host='localhost',
#         user='root',
#         password='Kuku0809',
#         database='university_scholarship'
#     )
#     return connection

# # API to validate login
# @app.route('/login', methods=['POST'])
# def login():
#     user_type = request.json.get('user_type')
#     if user_type == 'student':
#         return jsonify({'message': 'Student logged in'}), 200
#     elif user_type == 'management':
#         return jsonify({'message': 'Management logged in'}), 200
#     else:
#         return jsonify({'error': 'Invalid user type'}), 400

# # API to view student details
# @app.route('/student/view', methods=['POST'])
# def view_student_details():
#     SRN = request.json.get('SRN')
#     connection = get_db_connection()
#     cursor = connection.cursor()
#     cursor.execute("SELECT * FROM students WHERE SRN=%s", (SRN,))
#     student = cursor.fetchone()
#     connection.close()
#     if student:
#         return jsonify({'student': student}), 200
#     else:
#         return jsonify({'error': 'Student not found'}), 404

# # API to check transaction status
# @app.route('/student/transaction', methods=['POST'])  # Added route decorator
# def check_transaction_status():
#     SRN = request.json.get('SRN') 
#     connection = get_db_connection()
#     cursor = connection.cursor() 
#     cursor.execute("SELECT Transaction_Status, Type_of_Scholarship FROM Status WHERE SRN=%s", (SRN,))
    
#     transaction = cursor.fetchone() 
#     connection.close()
    
#     if transaction: 
#         return jsonify({
#             'transaction_status': transaction[0],
#             'type_of_scholarship': transaction[1]
#         }), 200
#     else:
#         return jsonify({'error': 'No transactions found for this SRN'}), 404

# # API to view staff details
# @app.route('/management/view_staff', methods=['POST'])
# def view_staff_details():
#     Staff_ID = request.json.get('Staff_ID')
#     connection = get_db_connection()
#     cursor = connection.cursor()
#     cursor.execute("SELECT * FROM Staff WHERE Staff_ID=%s", (Staff_ID,))
#     staff = cursor.fetchone()
#     connection.close()
#     if staff:
#         return jsonify({'staff': staff}), 200
#     else:
#         return jsonify({'error': 'Staff not found'}), 404

# # API to edit student details
# @app.route('/management/edit_student', methods=['POST'])
# def edit_student_details():
#     data = request.json
#     SRN = data.get('SRN')

#     if not SRN:
#         return jsonify({'error': 'SRN is required'}), 400

#     # Building the SQL query dynamically to update only the provided fields
#     fields_to_update = []
#     values = []
    
#     if 'Name' in data:
#         fields_to_update.append("Name=%s")
#         values.append(data['Name'])
        
#     if 'Semester' in data:
#         fields_to_update.append("Semester=%s")
#         values.append(data['Semester'])
    
#     if 'Section' in data:
#         fields_to_update.append("Section=%s")
#         values.append(data['Section'])
        
#     if 'Branch' in data:
#         fields_to_update.append("Branch=%s")
#         values.append(data['Branch'])
        
#     if 'Gender' in data:
#         fields_to_update.append("Gender=%s")
#         values.append(data['Gender'])
    
#     if 'Date_of_Birth' in data:
#         fields_to_update.append("Date_of_Birth=%s")
#         values.append(data['Date_of_Birth'])
        
#     if 'Street' in data:
#         fields_to_update.append("Street=%s")
#         values.append(data['Street'])
    
#     if 'City' in data:
#         fields_to_update.append("City=%s")
#         values.append(data['City'])
    
#     if 'State' in data:
#         fields_to_update.append("State=%s")
#         values.append(data['State'])
    
#     if 'CGPA' in data:
#         fields_to_update.append("CGPA=%s")
#         values.append(data['CGPA'])
    
#     if 'SGPA' in data:
#         fields_to_update.append("SGPA=%s")
#         values.append(data['SGPA'])
    
#     if 'Credits_received' in data:
#         fields_to_update.append("Credits_received=%s")
#         values.append(data['Credits_received'])
    
#     if 'Credits_required' in data:
#         fields_to_update.append("Credits_required=%s")
#         values.append(data['Credits_required'])
    
#     if 'Account_number' in data:
#         fields_to_update.append("Account_number=%s")
#         values.append(data['Account_number'])
    
#     if 'IFSC_code' in data:
#         fields_to_update.append("IFSC_code=%s")
#         values.append(data['IFSC_code'])
    
#     if 'Fee_category' in data:
#         fields_to_update.append("Fee_category=%s")
#         values.append(data['Fee_category'])
    
#     if 'Fee_amount' in data:
#         fields_to_update.append("Fee_amount=%s")
#         values.append(data['Fee_amount'])
    
#     if 'Payment_status' in data:
#         fields_to_update.append("Payment_status=%s")
#         values.append(data['Payment_status'])
    
#     if 'Eligibility' in data:
#         fields_to_update.append("Eligibility=%s")
#         values.append(data['Eligibility'])

#     # If there are fields to update, proceed
#     if fields_to_update:
#         query = f"UPDATE Students SET {', '.join(fields_to_update)} WHERE SRN=%s"
#         values.append(SRN)
        
#         # Execute the update query
#         connection = get_db_connection()
#         cursor = connection.cursor()
#         cursor.execute(query, tuple(values))
#         connection.commit()
#         connection.close()

#         return jsonify({'message': 'Student details updated successfully'}), 200
#     else:
#         return jsonify({'error': 'No fields to update'}), 400

# @app.route('/management/edit_transaction', methods=['POST'])
# def edit_transaction_status():
#     data = request.json
#     SRN = data.get('SRN')
#     Name = data.get('Name')
#     status = data.get('status') 
#     if not SRN or not Name or not status:
#         return jsonify({'error': 'SRN, Name, and status are required'}), 400

#     connection = get_db_connection()
#     cursor = connection.cursor() 
#     cursor.execute("""
#         UPDATE Status 
#         SET Transaction_Status=%s 
#         WHERE SRN=%s AND Name=%s
#     """, (status, SRN, Name)) 
#     connection.commit()
#     connection.close()

#     return jsonify({'message': 'Transaction status updated successfully'}), 200


# if __name__ == '__main__':
#     app.run(debug=True)