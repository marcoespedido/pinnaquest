import sys
import json
import fitz  # PyMuPDF
import re
import warnings
from groq import Groq


# Patayin ang lahat ng warnings para JSON lang ang makita ng PHP
warnings.filterwarnings("ignore")


# ILAGAY DITO ANG IYONG GROQ API KEY
client = Groq(api_key="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")


def super_clean(text):
    # Alisin ang university headers (Pamantasan ng Cabuyao)
    text = re.sub(r'(?i)PAMANTASAN\s+NG\s+CABUYAO.*?(ENGINEERING\s+\d+|SOFTWARE\s+ENGINEERING)', '', text)
   
    # Putulin ang text bago ang References para malinis
    stop_words = ["REFERENCES", "RESOURCES NEEDED", "BIBLIOGRAPHY", "LEARNING OUTCOMES", "INTRODUCTION", ]
    for word in stop_words:
        if word in text.upper():
            text = text.upper().split(word)[0]
           
    text = re.sub(r'\n', ' ', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()


def process_with_groq(text, difficulty="easy", quiz_type="multiple_choice", count=5):
    try:
        # Limit text chunk para sa efficiency
        prompt_text = text[:120000]


        # Eksaktong logic base sa "Question Generation Rules" table
        difficulty_rules = {
            "easy": (
                "STRATEGY: EASY. For MCQs: Use direct fact questions. Replace named entities with What/Who/Where. "
                "Distractors must be from other unrelated entities. "
                "For Fill-in-the-blanks: Remove a key term from a definition sentence."
            ),
            "medium": (
                "STRATEGY: MEDIUM. For MCQs: Use conceptual questions from topic sentences. "
                "Distractors must be from the same section to increase difficulty. "
                "For Fill-in-the-blanks: Remove a concept or noun phrase from an explanatory sentence."
            ),
            "hard": (
                "STRATEGY: HARD. For MCQs: Use inference questions that combine information from multiple sentences. "
                "Distractors must be from different sections of the text. "
                "For Fill-in-the-blanks: Remove a term from a complex, contextual sentence."
            )
        }


        # Pag-handle kung "Fill in the Blanks" ang pinili
        quiz_format_instruction = ""
        if "fill" in quiz_type.lower():
            quiz_format_instruction = (
                "For Fill-in-the-blanks: The 'question' string must contain an underscore (____). "
                "The 'options' array must be empty [], 'answer_index' must be -1, and 'answer' is the missing word."
                "IMPORTANT: Add a new key 'distractors' which is an array of 3 other words from the text that are NOT the answer."
            )
        else:
            quiz_format_instruction = (
                "For Multiple Choice: Each question must have 'options' (array of 4 strings), "
                "'answer_index' (0-3), and 'answer' (the string value of the correct option)."
            )


        chat_completion = client.chat.completions.create(
            messages=[
                {
                    "role": "system",
                    "content": (
                        "You are an expert academic assistant. Output ONLY a valid JSON object. "
                        "1. SUMMARIZATION: Provide 'overview' (clear summary), 'key_terminologies' (list of 'Term: Definition' strings), "
                        "and 'main_study_points' (list of 7-10 bullet points). "
                        f"2. QUIZ: Generate exactly {count} {quiz_type} questions. "
                        f"DIFFICULTY RULE: {difficulty_rules.get(difficulty.lower(), difficulty_rules['easy'])} "
                        f"{quiz_format_instruction} "
                        "JSON structure: {'overview': '', 'key_terminologies': [], 'main_study_points': [], 'quiz': [{'question': '', 'options': [], 'answer_index': 0, 'answer': ''}]}"
                    )
                },
                {"role": "user", "content": f"SOURCE TEXT: {prompt_text}"}
            ],
            model="llama-3.3-70b-versatile",
            response_format={"type": "json_object"}
        )
        return json.loads(chat_completion.choices[0].message.content)
    except Exception as e:
        return {"error": str(e)}


def main():
    if len(sys.argv) > 1:
        pdf_path = sys.argv[1]
       
        # Pagkuha ng arguments mula sa PHP
        difficulty = sys.argv[2] if len(sys.argv) > 2 else "easy"
        quiz_type = sys.argv[3] if len(sys.argv) > 3 else "multiple_choice"
        count = sys.argv[4] if len(sys.argv) > 4 else 5


        try:
            doc = fitz.open(pdf_path)
            raw_text = " ".join([page.get_text() for page in doc])
            cleaned_text = super_clean(raw_text)
           
            result = process_with_groq(cleaned_text, difficulty, quiz_type, count)
           
            # Siguraduhin na UTF-8 ang output para sa special characters
            sys.stdout.buffer.write(json.dumps(result, ensure_ascii=False).encode('utf-8'))
        except Exception as e:
            print(json.dumps({"error": str(e)}))


if __name__ == "__main__":
    main()
