from experiment.api.models import Participant, ChatDialog, ChatMessage, Questionnaire, FinalQuestionnaire

import datetime
import pytz
import xlwt

numbers = range(1, 25)
participants = Participant.objects.filter(number__in=numbers)

def excel_date(date):
    temp = datetime.datetime(1899, 12, 30, 0, 0, 0, 0, pytz.UTC)    # Note, not 31st Dec but 30th!
    delta = date - temp
    return float(delta.days) + (float(delta.seconds) / 86400)

def write_participants(ws):
    row = 0
    ws.write(row, 0, "Number")
    ws.write(row, 1, "Group")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        ws.write(row, 1, p.group)
        row += 1

def write_dialogs(ws):
    row = 0
    ws.write(row, 0, "Participant")
    ws.write(row, 1, "Total dialogs")
    ws.write(row, 2, "Finished dialogs")
    ws.write(row, 3, "Condition")
    ws.write(row, 4, "Part")
    ws.write(row, 5, "Dialogs in condition")
    ws.write(row, 6, "Finished dialogs in condition")
    ws.write(row, 7, "Topic")
    ws.write(row, 8, "Ended")
    ws.write(row, 9, "Responses")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        ws.write(row, 1, dialogs.count())
        ws.write(row, 2, dialogs.filter(is_ended=True).count())
        a_dialogs = dialogs.filter(experiment_condition="A")
        ws.write(row, 3, "A")
        ws.write(row, 4, a_dialogs[0].experiment_part)
        ws.write(row, 5, a_dialogs.count())
        ws.write(row, 6, a_dialogs.filter(is_ended=True).count())
        for d in a_dialogs:
            ws.write(row, 7, d.subject)
            ws.write(row, 8, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 9, responses.count())
            row += 1
        row += 1
        b_dialogs = dialogs.filter(experiment_condition="B")
        ws.write(row, 3, "B")
        ws.write(row, 4, b_dialogs[0].experiment_part)
        ws.write(row, 5, b_dialogs.count())
        ws.write(row, 6, b_dialogs.filter(is_ended=True).count())
        for d in b_dialogs:
            ws.write(row, 7, d.subject)
            ws.write(row, 8, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 9, responses.count())
            row += 1
        row += 1
        c_dialogs = dialogs.filter(experiment_condition="C")
        ws.write(row, 3, "C")
        ws.write(row, 4, c_dialogs[0].experiment_part)
        ws.write(row, 5, c_dialogs.count())
        ws.write(row, 6, c_dialogs.filter(is_ended=True).count())
        for d in c_dialogs:
            ws.write(row, 7, d.subject)
            ws.write(row, 8, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 9, responses.count())
            row += 1
        row += 1
        d_dialogs = dialogs.filter(experiment_condition="D")
        ws.write(row, 3, "D")
        if d_dialogs:
            ws.write(row, 4, d_dialogs[0].experiment_part)
        ws.write(row, 5, d_dialogs.count())
        ws.write(row, 6, d_dialogs.filter(is_ended=True).count())
        for d in d_dialogs:
            ws.write(row, 7, d.subject)
            ws.write(row, 8, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 9, responses.count())
            row += 1
        row += 1

def write_questions_and_answers(ws):
    row = 0
    ws.write(row, 0, "Participant")
    ws.write(row, 1, "Condition")
    ws.write(row, 2, "Part")
    ws.write(row, 3, "Topic")
    ws.write(row, 4, "Question")
    ws.write(row, 5, "Answer")
    ws.write(row, 6, "Wait time (s)")
    ws.write(row, 7, "Correct")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            ws.write(row, 1, d.experiment_condition)
            ws.write(row, 2, d.experiment_part)
            ws.write(row, 3, d.subject)
            messages = ChatMessage.objects.filter(chat_dialog=d, type=2).order_by('created_at')
            row_changed = True
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                    if not row_changed:
                        row += 1
                    ws.write(row, 4, m.message)
                    row_changed = False
                elif m.sender_type == 2:
                    ws.write(row, 5, m.message)
                    wait_time = (m.created_at - wait_time_started_at).total_seconds()
                    ws.write(row, 6, wait_time)
                    row += 1
                    row_changed = True
            if row_changed:
                row += 1
            else:
                row += 2
        row += 1

def write_first_response_times(ws):
    row = 0
    ws.write(row, 0, "Participant")
    ws.write(row, 1, "Condition")
    ws.write(row, 2, "Part")
    ws.write(row, 3, "Topic")
    ws.write(row, 4, "First response time")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            ws.write(row, 1, d.experiment_condition)
            ws.write(row, 2, d.experiment_part)
            ws.write(row, 3, d.subject)
            messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
            row_changed = True
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                    if not row_changed:
                        row += 1
                    row_changed = False
                elif m.sender_type == 2:
                    wait_time = (m.created_at - wait_time_started_at).total_seconds()
                    ws.write(row, 4, wait_time)
                    row += 1
                    row_changed = True
            if not row_changed:
                row += 1
        row += 1

def write_last_response_times(ws):
    row = 0
    ws.write(row, 0, "Participant")
    ws.write(row, 1, "Condition")
    ws.write(row, 2, "Part")
    ws.write(row, 3, "Topic")
    ws.write(row, 4, "Last response time")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            ws.write(row, 1, d.experiment_condition)
            ws.write(row, 2, d.experiment_part)
            ws.write(row, 3, d.subject)
            messages = ChatMessage.objects.filter(chat_dialog=d, type=4).order_by('created_at')
            row_changed = True
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                    if not row_changed:
                        row += 1
                    row_changed = False
                elif m.sender_type == 2:
                    if wait_time_started_at:
                        wait_time = (m.created_at - wait_time_started_at).total_seconds()
                        ws.write(row, 4, wait_time)
                        row += 1
                        row_changed = True
            if not row_changed:
                row += 2
            else:
                row += 1
        row += 1

def write_reaction_times(ws):
    row = 0
    ws.write(row, 0, "Participant")
    ws.write(row, 1, "Condition")
    ws.write(row, 2, "Part")
    ws.write(row, 3, "Topic")
    ws.write(row, 4, "Message")
    ws.write(row, 5, "Reaction")
    ws.write(row, 6, "Reaction time")
    ws.write(row, 7, "Pieni hetki")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            ws.write(row, 1, d.experiment_condition)
            ws.write(row, 2, d.experiment_part)
            ws.write(row, 3, d.subject)
            messages = ChatMessage.objects.filter(chat_dialog=d).order_by('created_at')
            row_changed = True
            wait_time_started_at = None
            for m in messages:
                if m.sender_type == 1:
                    wait_time_started_at = m.created_at
                    if not row_changed:
                        row += 1
                    ws.write(row, 4, m.message)
                    row_changed = False
                elif m.sender_type == 2:
                    if wait_time_started_at:
                        ws.write(row, 5, m.message)
                        wait_time = (m.created_at - wait_time_started_at).total_seconds()
                        ws.write(row, 6, wait_time)
                        pieni_hetki = m.type == 3
                        ws.write(row, 7, pieni_hetki)
                        wait_time_started_at = None
                        row += 1
                        row_changed = True
            if not row_changed:
                row += 1
        row += 1

def write_data():
    wb = xlwt.Workbook()
    participants_sheet = wb.add_sheet('Participants')
    write_participants(participants_sheet)
    dialogs_sheet = wb.add_sheet('ChatDialogs')
    write_dialogs(dialogs_sheet)
    qa_sheet = wb.add_sheet('Q&A')
    write_questions_and_answers(qa_sheet)
    first_response_sheet = wb.add_sheet('First response times')
    write_first_response_times(first_response_sheet)
    last_response_sheet = wb.add_sheet('Last response times')
    write_last_response_times(last_response_sheet)
    reaction_time_sheet = wb.add_sheet('Reaction times')
    write_reaction_times(reaction_time_sheet)


    wb.save('data.xls')
