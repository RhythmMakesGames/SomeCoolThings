#include<iostream>

void printInorder(struct Node *node);
void printPreorder(struct Node *node);
void printPostorder(struct Node *node);

struct Node
{
	int data;
	Node *left, *right;
};

Node* createNode(int data)
{
	Node *temp = new Node;
	temp->data = data;
	temp->left = nullptr;
	temp->right = nullptr;

	return temp;
}

int main()
{
	// Initializing tree
	Node *root = createNode(1);
	root->left = createNode(2);
	root->right = createNode(3);
	root->left->left = createNode(4);
	root->left->right = createNode(5);
	root->right->left = createNode(6);
	
	// Printing values in Inorder
	std::cout <<"Inorder: ";
	printInorder(root);
	std::cout <<"\n";
	
	// Printing values in Preorder
	std::cout <<"Preorder: ";
	printPreorder(root);
	std::cout <<"\n";

	// Printing values in Postorder
	std::cout <<"Postorder: ";
	printPostorder(root);
	std::cout <<"\n";
	
	return 0;
}

void printInorder(Node *node)
{
	if (node == nullptr) {
		return;
	}
	
	printInorder(node->left);
	std::cout << node->data << " ";
	printInorder(node->right);
}

void printPreorder(Node *node)
{
	if (node == nullptr) {
		return;
	}
	
	std::cout << node->data << " ";
	printPreorder(node->left);
	printPreorder(node->right);
}

void printPostorder(Node *node)
{
	if (node == nullptr) {
		return;
	}
	
	printPostorder(node->left);
	printPostorder(node->right);
	std::cout << node->data << " ";
}

// other ones later ig
