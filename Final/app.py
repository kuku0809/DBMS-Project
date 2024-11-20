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

def is_hashed(password):
    # bcrypt hashed passwords are 60 characters long and start with $2b$
    return len(password) == 60 and password.startswith("$2b$")


# API to validate login@app.route('/login', methods=['POST'])
@app.route('/login', methods=['POST'])
def login():
    if request.method == 'OPTIONS':
        return jsonify({'status': 'OK'}), 200
    global username
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
        # Check if the user exists in MySQL
        cursor.execute("SELECT EXISTS (SELECT 1 FROM mysql.user WHERE user = %s) AS user_exists", (username,))
        user_exists = cursor.fetchone()['user_exists']  # Accessing the key instead of using an index

        if student and student['password'] == password:  # Add password hash check if needed
            if not user_exists:
                cursor.execute("CREATE USER %s IDENTIFIED BY %s", (username, password))
                conn.commit()
                cursor.execute("GRANT student TO %s", (username,))
                conn.commit()
            return jsonify({'message': 'Student logged in'}), 200
        else:
            return jsonify({'error': 'Invalid username or password'}), 401



    elif user_type == 'management':
        # Query to validate staff login
        cursor.execute("SELECT Staff_ID, password FROM staff WHERE Staff_ID = %s", (username,))
        staff = cursor.fetchone()
        # Check if the user exists in MySQL
        cursor.execute("SELECT EXISTS (SELECT 1 FROM mysql.user WHERE user = %s) AS user_exists", (username,))
        user_exists = cursor.fetchone()['user_exists']  # Accessing the key instead of using an index

        if staff and staff['password'] == password:
            if not user_exists:
                cursor.execute("CREATE USER %s IDENTIFIED BY %s", (username, password))
                conn.commit()
                cursor.execute("GRANT management TO %s", (username,))
                conn.commit()
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
    # SRN = data.get('SRN')
    SRN=username
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
    #SRN = request.json.get('SRN')
    SRN=username
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
    #SRN = request.json.get('SRN')
    SRN=username
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


# API to view student details in the management section
@app.route('/management/view_student', methods=['POST'])
def management_view_student_details():
    data = request.json 
    SRN = data.get('SRN')  # Get the SRN from the request 

    connection = get_db_connection()
    cursor = connection.cursor()

    # Validate that the staff member has the right to view student details
    cursor.execute("SELECT * FROM students WHERE SRN=%s", (SRN,)) 
    student = cursor.fetchone()

    cursor.close()
    connection.close()

    if student:
        return jsonify({'student': student}), 200
    else:
        return jsonify({'error': 'Student not found'}), 404



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


# @app.route('/management/view_transaction', methods=['POST'])
# def view_transaction_details():
#     # Assuming you get the SRN from the request
#     SRN = request.json.get('SRN')
#     connection = get_db_connection()
#     cursor = connection.cursor()
    
#     # Update the SQL query to retrieve all relevant transaction details
#     cursor.execute("SELECT Transaction_Status, Type_of_Scholarship, Scholarship_amount, Name FROM Status WHERE SRN=%s", (SRN,))

#     transaction_details = cursor.fetchone()
#     connection.close()

#     # If there are details, format the output
#     if transaction_details:  
#             return jsonify({
#                 'transaction_status': transaction_details[0],
#                 'type_of_scholarship': transaction_details[1],
#                 'scholarship_amount': transaction_details[2],
#                 'name': transaction_details[3]
#             }),200 
#     else:
#         return jsonify({'error': 'No transactions found for this SRN'}), 404


@app.route('/management/view_transaction', methods=['POST'])
def view_transaction_details():
    SRN = request.json.get('SRN')
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)

    try:
        # Call the stored procedure
        cursor.callproc('GetTransactionDetails', (SRN,))

        # Fetch the results from the first result set
        transaction_details = None
        for result in cursor.stored_results():
            transaction_details = result.fetchall()
            break  # We only expect one result set

        # Check if the transaction details were found
        if transaction_details:
            return jsonify({
                'transaction_status': transaction_details[0]['Transaction_Status'],
                'type_of_scholarship': transaction_details[0]['Type_of_Scholarship'],
                'scholarship_amount': transaction_details[0]['Scholarship_amount'],
                'name': transaction_details[0]['Name']
            }), 200 
        else:
            return jsonify({'error': 'No transactions found for this SRN'}), 404

    except mysql.connector.Error as err:
        logging.error(f"Error occurred: {err}")
        return jsonify({'error': str(err)}), 500
    finally:
        cursor.close()
        connection.close()



# API to edit staff details
@app.route('/management/edit_staff', methods=['POST'])
def edit_staff_details():
    data = request.json
    Staff_ID = data.get('Staff_ID')

    if not Staff_ID:
        return jsonify({'error': 'All fields are required'}), 400

    # Building the SQL query dynamically to update only the provided fields
    fields_to_update = []
    values = []

    if 'Name' in data:
        fields_to_update.append("Name=%s")
        values.append(data['Name'])

    if 'Department_ID' in data:
        fields_to_update.append("Department_ID=%s")
        values.append(data['Department_ID'])

    if 'Department_name' in data:
        fields_to_update.append("Department_name=%s")
        values.append(data['Department_name'])

    if 'College_email' in data:
        fields_to_update.append("College_email=%s")
        values.append(data['College_email'])

    # If there are fields to update, proceed
    if fields_to_update:
        query = f"UPDATE Staff SET {', '.join(fields_to_update)} WHERE Staff_ID=%s"
        values.append(Staff_ID)

        # Execute the update query
        connection = get_db_connection()
        cursor = connection.cursor()
        try:
            cursor.execute(query, tuple(values))
            connection.commit()
            return jsonify({'message': 'Staff details updated successfully'}), 200
        except mysql.connector.Error as err:
            return jsonify({'error': str(err)}), 400
        finally:
            cursor.close()
            connection.close()
    else:
        return jsonify({'error': 'No fields to update'}), 400


@app.route('/management/delete_student', methods=['DELETE'])
def delete_student():
    SRN = request.json.get('SRN')

    if not SRN:
        return jsonify({'error': 'SRN is required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()

    try:
        # Check if the student exists
        cursor.execute("SELECT * FROM Students WHERE SRN = %s", (SRN,))
        student = cursor.fetchone()

        if not student:
            return jsonify({'error': 'Student not found'}), 404

        # Delete the student record
        cursor.execute("DELETE FROM Students WHERE SRN = %s", (SRN,))
        connection.commit()

        return jsonify({'message': 'Student and associated records deleted successfully'}), 200

    except mysql.connector.Error as err:
        connection.rollback()
        return jsonify({'error': str(err)}), 400

    finally:
        cursor.close()
        connection.close()


# API to edit student details
@app.route('/management/edit_student', methods=['POST'])
def edit_student_details():
    data = request.json
    SRN = data.get('SRN')

    if not SRN:
        return jsonify({'error': 'All fields are required'}), 400

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


# API to delete a staff record using stored procedure
import logging

# Configure logging
logging.basicConfig(level=logging.DEBUG)

@app.route('/management/delete_staff', methods=['POST'])
def delete_staff():
    staffid= request.json.get('Staff_ID')

    if not staffid:
        return jsonify({'error': 'staffid is required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()

    try:
        # Check if the student exists
        cursor.execute("SELECT * FROM Staff WHERE Staff_ID = %s", (staffid,))
        student = cursor.fetchone()

        if not staffid:
            return jsonify({'error': 'Staff not found'}), 404

        # Delete the student record
        cursor.execute("DELETE FROM Staff WHERE Staff_ID = %s", (staffid,))
        connection.commit()

        return jsonify({'message': 'Staff records deleted successfully'}), 200

    except mysql.connector.Error as err:
        connection.rollback()
        return jsonify({'error': str(err)}), 400

    finally:
        cursor.close()
        connection.close()






@app.route('/management/edit_transaction', methods=['POST'])
def edit_transaction_status():
    data = request.json
    print("Request Data:", data)  # Debugging line
    SRN = data.get('SRN')
    status = data.get('status')

    if not SRN or not status:
        return jsonify({'error': 'SRN and status are required'}), 400

    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        cursor.execute("""
            UPDATE Status 
            SET Transaction_Status=%s 
            WHERE SRN=%s
        """, (status, SRN))
        
        if cursor.rowcount == 0:
            return jsonify({'error': 'No transaction found for the given SRN'}), 404
        
        connection.commit()
    except mysql.connector.Error as e:
        return jsonify({'error': str(e)}), 500
    finally:
        connection.close()

    return jsonify({'message': 'Transaction status updated successfully'}), 200



# API to get scholarship distribution based on semester, branch, and section
@app.route('/management/scholarship_distribution', methods=['POST'])
def scholarship_distribution():
    data = request.json
    semester = data.get('semester')
    branch = data.get('branch')
    section = data.get('section')

    if not semester or not branch or not section:
        return jsonify({'error': 'Semester, branch, and section are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()

    # Query to get the count of students who got each type of scholarship (MRD, CNR, DAC)
    query = """
        SELECT s.Type_of_Scholarship, COUNT(st.SRN) as student_count
        FROM status s
        JOIN students st ON s.SRN = st.SRN
        WHERE st.Semester = %s AND st.Branch = %s AND st.Section = %s
        AND s.Type_of_Scholarship IN ('MRD', 'CNR', 'DAC')
        GROUP BY s.Type_of_Scholarship
    """
    cursor.execute(query, (semester, branch, section))
    results = cursor.fetchall()

    cursor.close()
    conn.close()

    if results:
        scholarships = [{'type_of_scholarship': row[0], 'student_count': row[1]} for row in results]
        return jsonify({'scholarship_distribution': scholarships}), 200
    else:
        return jsonify({'message': 'No students found for the given criteria'}), 404


# API to get total scholarship allocation for all students
@app.route('/management/scholarship_allocation', methods=['POST'])
def scholarship_allocation():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Query to get the count of students and the respective amounts for each scholarship type
    allocation_query = """
        SELECT 
            s.Type_of_Scholarship, 
            COUNT(st.SRN) AS student_count,
            SUM(CASE 
                WHEN s.Type_of_Scholarship = 'MRD' THEN ad.MRD_amount 
                WHEN s.Type_of_Scholarship = 'CNR' THEN ad.CNR_amount 
                WHEN s.Type_of_Scholarship = 'DAC' THEN ad.DAC_amount 
            END) AS scholarship_amount
        FROM 
            status s
        JOIN 
            students st ON s.SRN = st.SRN
        JOIN 
            Amount_Details ad ON st.Semester = ad.Semester AND st.Branch = ad.Branch 
        WHERE 
            s.Transaction_Status = 'Completed' AND 
            s.Type_of_Scholarship IN ('MRD', 'CNR', 'DAC')
        GROUP BY 
            s.Type_of_Scholarship
    """

    cursor.execute(allocation_query)
    allocations = cursor.fetchall()

    # Initialize total allocation dictionary
    total_allocation = {'MRD': 0, 'CNR': 0, 'DAC': 0}

    # Populate total allocation dictionary
    for scholarship_type, student_count, scholarship_amount in allocations:
        total_allocation[scholarship_type] += student_count * scholarship_amount

    cursor.close()
    conn.close()

    return jsonify({'allocation': total_allocation}), 200


@app.route('/scholarship_stats', methods=['POST'])
def get_scholarship_stats():
    semester = request.json.get('semester')

    if not semester:
        return jsonify({'error': 'Semester is required'}), 400

    try:
        semester = int(semester)
        if semester < 1 or semester > 8:
            return jsonify({'error': 'Semester must be between 1 and 8'}), 400
    except ValueError:
        return jsonify({'error': 'Invalid semester input'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = """
    SELECT 
        Fee_category,
        Type_of_Scholarship,
        COUNT(*) AS student_count
    FROM (
        SELECT 
            S.Fee_category,
            ST.Type_of_Scholarship
        FROM 
            Students S
        JOIN 
            Status ST ON S.SRN = ST.SRN
        WHERE 
            S.Semester = %s AND 
            ST.Type_of_Scholarship IN ('MRD', 'CNR', 'DAC')
    ) AS filtered_students
    GROUP BY 
        Fee_category, Type_of_Scholarship
    """

    cursor.execute(query, (semester,))
    results = cursor.fetchall()

    cursor.close()
    conn.close()

    if results:
        return jsonify({'scholarship_statistics': results}), 200
    else:
        return jsonify({'message': 'No data found for the given semester'}), 404

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