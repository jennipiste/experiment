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
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "layout")
    ws.write(row, 3, "chats")
    ws.write(row, 4, "part")
    ws.write(row, 5, "topic")
    ws.write(row, 6, "ended")
    ws.write(row, 7, "responses")
    ws.write(row, 8, "dialogs_in_condition")
    ws.write(row, 9, "finished_dialogs_in_condition")
    ws.write(row, 10, "responses_in_condition")
    ws.write(row, 11, "total_dialogs")
    ws.write(row, 12, "finished_dialogs")
    ws.write(row, 13, "total_responses")
    row += 1

    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        ws.write(row, 11, dialogs.count())
        ws.write(row, 12, dialogs.filter(is_ended=True).count())
        total_responses = ChatMessage.objects.filter(chat_dialog__in=dialogs, sender_type=2, type=2).values('answer_to').distinct()
        ws.write(row, 13, total_responses.count())
        a_dialogs = dialogs.filter(experiment_condition="A")
        ws.write(row, 8, a_dialogs.count())
        ws.write(row, 9, a_dialogs.filter(is_ended=True).count())
        a_responses = ChatMessage.objects.filter(chat_dialog__in=a_dialogs, sender_type=2, type=2).values('answer_to').distinct()
        ws.write(row, 10, a_responses.count())
        for d in a_dialogs:
            ws.write(row, 0, p.number)
            ws.write(row, 1, "A")
            ws.write(row, 2, "1")
            ws.write(row, 3, "3")
            ws.write(row, 4, d.experiment_part)
            ws.write(row, 5, d.subject)
            ws.write(row, 6, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 7, responses.count())
            row += 1
        b_dialogs = dialogs.filter(experiment_condition="B")
        ws.write(row, 8, b_dialogs.count())
        ws.write(row, 9, b_dialogs.filter(is_ended=True).count())
        b_responses = ChatMessage.objects.filter(chat_dialog__in=b_dialogs, sender_type=2, type=2).values('answer_to').distinct()
        ws.write(row, 10, b_responses.count())
        for d in b_dialogs:
            ws.write(row, 0, p.number)
            ws.write(row, 1, "B")
            ws.write(row, 2, "2")
            ws.write(row, 3, "3")
            ws.write(row, 4, d.experiment_part)
            ws.write(row, 5, d.subject)
            ws.write(row, 6, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 7, responses.count())
            row += 1
        c_dialogs = dialogs.filter(experiment_condition="C")
        ws.write(row, 8, c_dialogs.count())
        ws.write(row, 9, c_dialogs.filter(is_ended=True).count())
        c_responses = ChatMessage.objects.filter(chat_dialog__in=c_dialogs, sender_type=2, type=2).values('answer_to').distinct()
        ws.write(row, 10, c_responses.count())
        for d in c_dialogs:
            ws.write(row, 0, p.number)
            ws.write(row, 1, "C")
            ws.write(row, 2, "1")
            ws.write(row, 3, "4")
            ws.write(row, 4, d.experiment_part)
            ws.write(row, 5, d.subject)
            ws.write(row, 6, d.is_ended)
            responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 7, responses.count())
            row += 1
        d_dialogs = dialogs.filter(experiment_condition="D")
        if d_dialogs:
            ws.write(row, 8, d_dialogs.count())
            ws.write(row, 9, d_dialogs.filter(is_ended=True).count())
            d_responses = ChatMessage.objects.filter(chat_dialog__in=d_dialogs, sender_type=2, type=2).values('answer_to').distinct()
            ws.write(row, 10, d_responses.count())
            for d in d_dialogs:
                ws.write(row, 0, p.number)
                ws.write(row, 1, "D")
                ws.write(row, 2, "2")
                ws.write(row, 3, "4")
                ws.write(row, 4, d.experiment_part)
                ws.write(row, 5, d.subject)
                ws.write(row, 6, d.is_ended)
                responses = ChatMessage.objects.filter(chat_dialog=d, sender_type=2, type=2).values('answer_to').distinct()
                ws.write(row, 7, responses.count())
                row += 1

def write_questions_and_answers(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "layout")
    ws.write(row, 3, "chats")
    ws.write(row, 4, "part")
    ws.write(row, 5, "topic")
    ws.write(row, 6, "question")
    ws.write(row, 7, "answer")
    ws.write(row, 8, "wait_time")
    ws.write(row, 9, "correct")
    row += 1

    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            questions = ChatMessage.objects.filter(chat_dialog=d, type=2, sender_type=1).order_by('created_at')
            for q in questions:
                responses = ChatMessage.objects.filter(answer_to=q)
                if responses:
                    r = responses.latest('created_at')
                    wait_time_started_at = q.created_at
                    ws.write(row, 0, p.number)
                    ws.write(row, 1, d.experiment_condition)
                    if d.experiment_condition == "A" or d.experiment_condition == "C":
                        ws.write(row, 2, "1")
                    else:
                        ws.write(row, 2, "2")
                    if d.experiment_condition == "A" or d.experiment_condition == "B":
                        ws.write(row, 3, "3")
                    else:
                        ws.write(row, 3, "4")
                    ws.write(row, 4, d.experiment_part)
                    ws.write(row, 5, d.subject)
                    ws.write(row, 6, q.message)
                    ws.write(row, 7, r.message)
                    wait_time = (r.created_at - wait_time_started_at).total_seconds()
                    ws.write(row, 8, wait_time)
                    row += 1

def write_first_response_times(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "layout")
    ws.write(row, 3, "chats")
    ws.write(row, 4, "part")
    ws.write(row, 5, "topic")
    ws.write(row, 6, "first_response_time")
    row += 1

    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d, type=1).order_by('created_at')
            if messages.count() > 1:
                ws.write(row, 0, p.number)
                ws.write(row, 1, d.experiment_condition)
                if d.experiment_condition == "A" or d.experiment_condition == "C":
                    ws.write(row, 2, "1")
                else:
                    ws.write(row, 2, "2")
                if d.experiment_condition == "A" or d.experiment_condition == "B":
                    ws.write(row, 3, "3")
                else:
                    ws.write(row, 3, "4")
                ws.write(row, 4, d.experiment_part)
                ws.write(row, 5, d.subject)
                wait_time_started_at = None
                for m in messages:
                    if m.sender_type == 1:
                        wait_time_started_at = m.created_at
                    elif m.sender_type == 2:
                        if wait_time_started_at:
                            wait_time = (m.created_at - wait_time_started_at).total_seconds()
                            ws.write(row, 6, wait_time)
                            wait_time_started_at = None
                            row += 1

def write_last_response_times(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "layout")
    ws.write(row, 3, "chats")
    ws.write(row, 4, "part")
    ws.write(row, 5, "topic")
    ws.write(row, 6, "last_response_time")
    row += 1

    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d, type=4).order_by('created_at')
            if messages.count() > 1:
                ws.write(row, 0, p.number)
                ws.write(row, 1, d.experiment_condition)
                if d.experiment_condition == "A" or d.experiment_condition == "C":
                    ws.write(row, 2, "1")
                else:
                    ws.write(row, 2, "2")
                if d.experiment_condition == "A" or d.experiment_condition == "B":
                    ws.write(row, 3, "3")
                else:
                    ws.write(row, 3, "4")
                ws.write(row, 4, d.experiment_part)
                ws.write(row, 5, d.subject)
                wait_time_started_at = None
                for m in messages:
                    if m.sender_type == 1:
                        wait_time_started_at = m.created_at
                    elif m.sender_type == 2:
                        if wait_time_started_at:
                            wait_time = (m.created_at - wait_time_started_at).total_seconds()
                            ws.write(row, 6, wait_time)
                            wait_time_started_at = None
                            row += 1

def write_reaction_times(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "layout")
    ws.write(row, 3, "chats")
    ws.write(row, 4, "part")
    ws.write(row, 5, "topic")
    ws.write(row, 6, "message")
    ws.write(row, 7, "reaction")
    ws.write(row, 8, "reaction_time")
    ws.write(row, 9, "pieni_hetki")
    row += 1

    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            messages = ChatMessage.objects.filter(chat_dialog=d).order_by('created_at')
            q = None
            a = None
            for m in messages:
                if m.sender_type == 1:
                    q = m
                    a = None
                elif m.sender_type == 2:
                    a = m
                if q and a:
                    ws.write(row, 0, p.number)
                    ws.write(row, 1, d.experiment_condition)
                    if d.experiment_condition == "A" or d.experiment_condition == "C":
                        ws.write(row, 2, "1")
                    else:
                        ws.write(row, 2, "2")
                    if d.experiment_condition == "A" or d.experiment_condition == "B":
                        ws.write(row, 3, "3")
                    else:
                        ws.write(row, 3, "4")
                    ws.write(row, 4, d.experiment_part)
                    ws.write(row, 5, d.subject)
                    ws.write(row, 6, q.message)
                    ws.write(row, 7, a.message)
                    wait_time = (a.created_at - q.created_at).total_seconds()
                    ws.write(row, 8, wait_time)
                    pieni_hetki = a.type == 3
                    ws.write(row, 9, pieni_hetki)
                    q = None
                    a = None
                    row += 1

def write_chat_durations(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "layout")
    ws.write(row, 3, "chats")
    ws.write(row, 4, "part")
    ws.write(row, 5, "topic")
    ws.write(row, 6, "duration")
    row += 1

    for p in participants:
        dialogs = ChatDialog.objects.filter(participant=p).order_by('experiment_condition', 'created_at')
        for d in dialogs:
            if d.is_ended:
                ws.write(row, 0, p.number)
                ws.write(row, 1, d.experiment_condition)
                if d.experiment_condition == "A" or d.experiment_condition == "C":
                    ws.write(row, 2, "1")
                else:
                    ws.write(row, 2, "2")
                if d.experiment_condition == "A" or d.experiment_condition == "B":
                    ws.write(row, 3, "3")
                else:
                    ws.write(row, 3, "4")
                ws.write(row, 4, d.experiment_part)
                ws.write(row, 5, d.subject)
                duration = (d.ended_at - d.created_at).total_seconds()
                ws.write(row, 6, duration)
                row += 1

def write_condition_counts_for_topics(ws):
    row = 0
    ws.write(row, 0, "topic")
    ws.write(row, 1, "condition_A")
    ws.write(row, 2, "condition_B")
    ws.write(row, 3, "condition_C")
    ws.write(row, 4, "condition_D")
    ws.write(row, 5, "part_1")
    ws.write(row, 6, "part_2")
    ws.write(row, 7, "part_3")
    ws.write(row, 8, "part_4")
    row += 1

    dialogs = ChatDialog.objects.filter(participant__in=participants)
    subjects = dialogs.values_list('subject', flat=True).distinct()
    for s in list(subjects):
        ws.write(row, 0, s)
        a_dialogs = dialogs.filter(subject=s, experiment_condition="A")
        ws.write(row, 1, a_dialogs.count())
        b_dialogs = dialogs.filter(subject=s, experiment_condition="B")
        ws.write(row, 2, b_dialogs.count())
        c_dialogs = dialogs.filter(subject=s, experiment_condition="C")
        ws.write(row, 3, c_dialogs.count())
        d_dialogs = dialogs.filter(subject=s, experiment_condition="D")
        ws.write(row, 4, d_dialogs.count())
        part1_dialogs = dialogs.filter(subject=s, experiment_part=1)
        ws.write(row, 5, part1_dialogs.count())
        part2_dialogs = dialogs.filter(subject=s, experiment_part=2)
        ws.write(row, 6, part2_dialogs.count())
        part3_dialogs = dialogs.filter(subject=s, experiment_part=3)
        ws.write(row, 7, part3_dialogs.count())
        part4_dialogs = dialogs.filter(subject=s, experiment_part=4)
        ws.write(row, 8, part4_dialogs.count())
        row += 1

def write_final_questionnaires(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "group")
    ws.write(row, 2, "more_pleasant")
    ws.write(row, 3, "more_efficient")
    ws.write(row, 4, "difference_between_3_and_4")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        ws.write(row, 1, p.group)
        q = FinalQuestionnaire.objects.get(participant=p)
        ws.write(row, 2, q.q1)
        ws.write(row, 3, q.q2)
        ws.write(row, 4, q.q3)
        row += 1

def write_questionnaires(ws):
    row = 0
    ws.write(row, 0, "participant")
    ws.write(row, 1, "condition")
    ws.write(row, 2, "part")
    ws.write(row, 3, "efficiency")
    ws.write(row, 4, "stress")
    ws.write(row, 5, "control")
    ws.write(row, 6, "frustration")
    ws.write(row, 7, "memory")
    row += 1

    for p in participants:
        ws.write(row, 0, p.number)
        questionnaires = Questionnaire.objects.filter(participant=p).order_by('experiment_condition')
        for q in questionnaires:
            ws.write(row, 1, q.experiment_condition)
            ws.write(row, 2, q.experiment_part)
            ws.write(row, 3, q.q1)
            ws.write(row, 4, q.q2)
            ws.write(row, 5, q.q3)
            ws.write(row, 6, q.q4)
            ws.write(row, 7, q.q5)
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
    chat_durations_sheet = wb.add_sheet('Chat durations')
    write_chat_durations(chat_durations_sheet)
    topics_sheet = wb.add_sheet('Topic stats')
    write_condition_counts_for_topics(topics_sheet)
    final_questionnaire_sheet = wb.add_sheet('Final questionnaires')
    write_final_questionnaires(final_questionnaire_sheet)
    questionnaire_sheet = wb.add_sheet('Questionnaires')
    write_questionnaires(questionnaire_sheet)
    wb.save('data.xls')
